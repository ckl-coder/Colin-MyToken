# Colin AMM - 简化版自动做市商

[![CI](https://github.com/Colin-KL/Colin-MyToken/actions/workflows/test.yml/badge.svg)](https://github.com/Colin-KL/Colin-MyToken/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一个基于 Uniswap V2 架构的简化版自动做市商（AMM）实现，使用 Foundry 开发框架构建。

## 功能特性

### ERC-20 代币功能
- ✅ 标准 ERC-20 功能（转账、授权、查询余额）
- ✅ 铸造（mint）和销毁（burn）功能
- ✅ 权限控制（只有 owner 可以铸造）

### AMM 流动性池功能
- ✅ **添加流动性** - 存入代币和 ETH，获得 LP Token
- ✅ **移除流动性** - 销毁 LP Token，取回代币和 ETH
- ✅ **代币兑换** - 使用恒定乘积公式 (x*y=k) 自动定价
- ✅ **滑点保护** - 防止大额交易导致的价格滑点损失

### 安全模块
- ✅ **暂停功能（Pausable）** - 紧急情况下暂停所有交易
- ✅ **重入锁保护（ReentrancyGuard）** - 防止重入攻击
- ✅ **黑名单机制** - 阻止特定地址参与交易

### 开发与部署
- ✅ 完整的测试覆盖
- ✅ CI/CD 自动化测试
- ✅ 前端管理界面（React + wagmi + RainbowKit）

## 技术栈

- **Solidity ^0.8.20** - 智能合约
- **Foundry** - 开发框架和测试
- **OpenZeppelin** - 安全数学库
- **Next.js + TypeScript** - 前端框架
- **wagmi + RainbowKit** - Web3 交互和钱包连接
- **Tailwind CSS** - 样式

## 快速开始

### 安装依赖

```bash
# 克隆项目
git clone https://github.com/Colin-KL/Colin-MyToken.git
cd Colin-MyToken

# 安装 Foundry 依赖
forge install
```

### 编译合约

```bash
forge build
```

### 运行测试

```bash
forge test
```

### 查看测试覆盖率

```bash
forge coverage
```

## 合约功能

### ERC-20 代币 (MyToken)

#### 基本信息
- **名称**: Colin
- **符号**: COL
- **小数位**: 18
- **总供应量**: 100,000 COL（初始）

#### 核心功能

| 功能 | 描述 | 访问权限 |
|------|------|----------|
| `transfer` | 转账代币 | 任何人（非暂停状态、非黑名单） |
| `approve` | 授权他人使用代币 | 代币持有者 |
| `transferFrom` | 代他人转账 | 被授权者（非暂停状态、非黑名单） |
| `mint` | 铸造新代币 | 仅 owner（非暂停状态） |
| `burn` | 销毁代币 | 代币持有者（非暂停状态） |
| `pause` | 暂停合约 | 仅 owner |
| `unpause` | 恢复合约 | 仅 owner |
| `addToBlacklist` | 添加地址到黑名单 | 仅 owner |
| `removeBlacklist` | 从黑名单移除地址 | 仅 owner |
| `isBlacklisted` | 查询地址是否在黑名单中 | 任何人 |

### AMM 流动性池 (LiquidityPool)

#### 核心功能

| 功能 | 描述 | 参数 |
|------|------|------|
| `addLiquidity` | 添加流动性 | `tokenAmount` - 代币数量（ETH 通过 msg.value 发送） |
| `removeLiquidity` | 移除流动性 | `lpAmount` - LP Token 数量 |
| `swapTokenForETH` | 用代币兑换 ETH | `tokenAmount` - 代币数量, `minEthOut` - 最小 ETH 输出（滑点保护） |
| `swapETHForToken` | 用 ETH 兑换代币 | `minTokenOut` - 最小代币输出（滑点保护） |

#### 定价机制

使用**恒定乘积公式**（Constant Product Market Maker）：

```
x * y = k

其中：
x = 代币储备量
y = ETH 储备量
k = 常数
```

**兑换计算示例：**
- 池子状态：1000 代币 + 10 ETH
- 用户兑换：100 代币 → ? ETH
- 新代币储备：1100
- 新 ETH 储备：1000 * 10 / 1100 = 9.09
- 用户得到：10 - 9.09 = 0.91 ETH

#### LP Token (LPToken)

LP Token 代表用户在流动性池中的份额：

**首次添加流动性：**
```
LP 数量 = √(代币数量 * ETH 数量)
```

**后续添加流动性：**
```
LP 数量 = min(
  代币数量 * 总 LP 供应量 / 代币储备,
  ETH 数量 * 总 LP 供应量 / ETH 储备
)
```

**移除流动性：**
```
代币数量 = LP 数量 * 代币储备 / 总 LP 供应量
ETH 数量 = LP 数量 * ETH 储备 / 总 LP 供应量
```

### 安全模块

#### 1. 暂停功能（Pausable）
- 紧急情况下可以暂停所有代币转账
- 只有合约 owner 可以暂停/恢复
- 暂停期间所有转账操作将回滚

#### 2. 重入锁保护（ReentrancyGuard）
- 防止重入攻击
- 保护 `transfer`、`transferFrom`、`mint`、`burn` 函数
- 使用状态锁机制确保函数安全执行

#### 3. 黑名单机制（Blacklist）
- 可以阻止特定地址参与交易
- 适用于合规要求或安全事件处理
- 只有 owner 可以管理黑名单

## 测试覆盖

### ERC-20 测试
- ✅ 代币基本信息查询
- ✅ 部署者初始余额验证
- ✅ 正常转账功能
- ✅ 余额不足转账失败
- ✅ 授权转账功能
- ✅ 铸造功能（owner）
- ✅ 非 owner 铸造失败
- ✅ 销毁功能

### 安全模块测试
- ✅ 暂停功能测试
- ✅ 重入攻击防护测试
- ✅ 黑名单功能测试

### AMM 功能测试（待添加）
- ⏳ 添加流动性测试
- ⏳ 移除流动性测试
- ⏳ 代币兑换测试
- ⏳ 滑点保护测试

## 前端界面

项目包含一个现代化的 Web 界面，支持：

- 🔗 钱包连接（MetaMask、WalletConnect 等）
- 📊 代币信息实时展示
- 💸 代币转账功能
- 💧 流动性添加/移除（开发中）
- 🔄 代币兑换（开发中）
- 📱 响应式设计

### 启动前端

```bash
cd my-frontend
npm install
npm run dev
```

访问 http://localhost:3000

## CI/CD

项目配置了 GitHub Actions，每次提交会自动：

1. 检查代码格式
2. 编译合约
3. 运行所有测试
4. 生成测试覆盖率报告

## 项目结构

```
.
├── src/
│   ├── MyToken.sol              # ERC-20 代币合约（继承安全模块）
│   ├── liquidity/
│   │   ├── LiquidityPool.sol    # AMM 流动性池合约
│   │   └── LPToken.sol          # LP Token 合约
│   ├── security/
│   │   ├── Pausable.sol         # 暂停功能模块
│   │   ├── ReentrancyGuard.sol  # 重入锁模块
│   │   └── Blacklist.sol        # 黑名单模块
│   └── interfaces/
├── test/
│   ├── MyTokenTest.t.sol        # 主合约测试
│   └── security/                # 安全模块测试
├── my-frontend/                 # 前端项目
│   ├── src/
│   │   ├── components/          # React 组件
│   │   └── app/                 # 页面
│   └── ...
├── .github/workflows/           # CI/CD 配置
└── README.md
```

## 与 Uniswap V2 的对比

| 功能 | Uniswap V2 | 本项目 | 状态 |
|------|-----------|--------|------|
| 恒定乘积公式 (x*y=k) | ✅ | ✅ | 已实现 |
| 添加/移除流动性 | ✅ | ✅ | 已实现 |
| 代币兑换 | ✅ | ✅ | 已实现 |
| 滑点保护 | ✅ | ✅ | 已实现 |
| LP Token 份额追踪 | ✅ | ✅ | 已实现 |
| 多交易对支持 | ✅ | ❌ | 单交易对 |
| 手续费机制 (0.3%) | ✅ | ❌ | 未实现 |
| 价格预言机 | ✅ | ❌ | 未实现 |
| 闪电贷 | ✅ | ❌ | 未实现 |
| 路由合约 | ✅ | ❌ | 未实现 |
| Factory 工厂合约 | ✅ | ❌ | 未实现 |
| 安全模块 | 基础 | ✅✅✅ | 更完善 |

## 许可证

MIT License

## 作者

Colin

---

*本项目用于学习和演示目的*
