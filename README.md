# Colin Token (COL)

[![CI](https://github.com/Colin-KL/Colin-MyToken/actions/workflows/test.yml/badge.svg)](https://github.com/Colin-KL/Colin-MyToken/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

一个基于 ERC-20 标准的代币合约项目，使用 Foundry 开发框架构建。

## 功能特性

- ✅ 标准 ERC-20 功能（转账、授权、查询余额）
- ✅ 铸造（mint）和销毁（burn）功能
- ✅ 权限控制（只有 owner 可以铸造）
- ✅ 完整的测试覆盖（8 个测试用例）
- ✅ CI/CD 自动化测试
- ✅ 前端管理界面（React + wagmi + RainbowKit）

## 技术栈

- **Solidity ^0.8.20** - 智能合约
- **Foundry** - 开发框架和测试
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

### 基本信息
- **名称**: Colin
- **符号**: COL
- **小数位**: 18
- **总供应量**: 100,000 COL（初始）

### 核心功能

| 功能 | 描述 | 访问权限 |
|------|------|----------|
| `transfer` | 转账代币 | 任何人 |
| `approve` | 授权他人使用代币 | 代币持有者 |
| `transferFrom` | 代他人转账 | 被授权者 |
| `mint` | 铸造新代币 | 仅 owner |
| `burn` | 销毁代币 | 代币持有者 |

## 测试覆盖

- ✅ 代币基本信息查询
- ✅ 部署者初始余额验证
- ✅ 正常转账功能
- ✅ 余额不足转账失败
- ✅ 授权转账功能
- ✅ 铸造功能（owner）
- ✅ 非 owner 铸造失败
- ✅ 销毁功能

## 前端界面

项目包含一个现代化的 Web 界面，支持：

- 🔗 钱包连接（MetaMask、WalletConnect 等）
- 📊 代币信息实时展示
- 💸 代币转账功能
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
│   └── MyToken.sol          # 代币合约
├── test/
│   └── MyTokenTest.t.sol    # 测试文件
├── my-frontend/             # 前端项目
│   ├── src/
│   │   ├── components/      # React 组件
│   │   └── app/             # 页面
│   └── ...
├── .github/workflows/       # CI/CD 配置
└── README.md
```

## 许可证

MIT License

## 作者

Colin

---

*本项目用于学习和演示目的*
