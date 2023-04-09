# Diamond Foundry

Welcome to the Diamond Foundry repository! This public project is focused on creating a powerful system for managing
universal and reusable smart contracts by leveraging the
[EIP2535 Diamond Proxy Standard](https://eips.ethereum.org/EIPS/eip-2535).

This repository contains the core code for the
[Diamond Factory and Facet Registry](https://medium.com/@alexeluca.spataru/achieving-universal-and-reusable-smart-contracts-via-erc2535-diamond-proxy-standard-ba4c9f5ac5bc),
which are designed to facilitate the creation of new Diamond proxies and manage their interactions with a library
template-like contracts called Facets.

Please note that this software is work in progress and is provided "as is" without warranty of any kind, use at your own
risk, not yet stable for production environments.

## Background

The Forgenie project aims to address the challenges associated with smart contract development and deployment, such as
complexity and the need for skilled developers and auditors. By using the
[Diamond Management System](https://medium.com/@alexeluca.spataru/transforming-web3-through-a-diamond-management-system-d2efa560ea7f),
the project proposes a more accessible and efficient method for building and managing smart contracts across the web3
landscape.

## Features

1. Facet Registry and Diamond Factory
1. Granular immutability for Diamonds.
1. Linting & Slither in CI
1. TBA Customizable Fallback function.
1. TBA Wide range of available and re-usable Facets.
1. TBA Ready-to-use deployment scripts
1. TBA Compose a Facet which is a Diamond over other Facets.

## Installation

This is a project fully built with [foundry](https://github.com/foundry-rs/foundry). If you are new to foundry, please
check the installation instructions.

Also, `pnpm` is used as a default package manager, so please follow [these](https://pnpm.io/installation) instructions
for installation.

For guidance on how to integrate a Foundry project in VSCode, please refer to this
[guide](https://book.getfoundry.sh/config/vscode).

### Set Up

```
git clone https://github.com/Forgenie/diamond-foundry.git
cd diamond-foundry
pnpm install
```

## Usage

This is a list of the most frequently needed commands.

Note: You need to have `foundry` installed in order to work with the contracts.

### Compile

Compile the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

### Lint

Lint the contracts:

```sh
$ pnpm lint
```

### Test

Run the tests:

```sh
$ forge test
```

## Contributing

We invite community members to contribute to the project by reviewing code, detecting bugs, developing new Facets, and
extending functionality.

Open up and review a PR, discussion or issue, and provide feedback by clearly explaining the changes and the motivation
behind.

### Guidelines

1. Adding facets

- Use `DiamondStorage` pattern for storing variables
- Interact with storage in the Behavior `library`
- Compose the final implementation in Facet `contract`
- If possible, don't use inherited `interface`
- Follow naming structure and rules of a Facet

2. Testing & naming

- Deploy test contracts in the `setUp` of an `abstract contract`
- Test facets by attaching their `interface` to a diamond address.
- There is one `Test` contract per each function within a Facet. It's naming should follow the `<Contract>_<method>`
  rule, so that we can isolate it with `--match-contract <REGEX>`.
- Facet Naming guidelines:
  - Optional: `<Name>Storage` for independent facet storage. Facets can be stateless and use other storage.
  - `<Name>Behavior` for behavior library.
  - `I<Name>` for interface, or should comply with eip number.
  - `<Name>Facet` final deployable implementation. Use the `Behavior` library here for defining functionality.

## License

MIT License (c) 2023 Forgenie Labs

## Acknowledgements

Nick Mudge @mudgen [diamond-hardhat](https://github.com/mudgen/diamond)<br /> Paul Razvan Berg @PaulRBerg
[foundry-template](https://github.com/PaulRBerg/foundry-template)
