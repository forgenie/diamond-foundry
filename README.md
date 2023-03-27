# Diamond Foundry

Welcome to the Diamond Foundry repository! This project is focused on creating a powerful system for managing universal and reusable smart contracts by leveraging the [EIP2535 Diamond Proxy Standard](https://eips.ethereum.org/EIPS/eip-2535). 

This repository contains the core code for the [Diamond Factory and Facet Registry](https://medium.com/@alexeluca.spataru/achieving-universal-and-reusable-smart-contracts-via-erc2535-diamond-proxy-standard-ba4c9f5ac5bc), which are designed to facilitate the creation of new Diamond proxies and manage their interactions with a library template-like contracts called Facets.

We invite community members to contribute to the project by detecting bugs, developing new Facets, and extending functionality. 

Please note that this software is provided "as is" without warranty of any kind.

## Background

The Forgenie project aims to address the challenges associated with smart contract development and deployment, such as complexity and the need for skilled developers and auditors. By using the [Diamond Management System](https://medium.com/@alexeluca.spataru/transforming-web3-through-a-diamond-management-system-d2efa560ea7f), the project proposes a more accessible and efficient method for building and managing smart contracts across the web3 landscape.


## Installation
This is a project fully built with [foundry](https://github.com/foundry-rs/foundry). If you are new to foundry, please check the installation instructions.

For guidance on how to integrate a Foundry project in VSCode, please refer to this
[guide](https://book.getfoundry.sh/config/vscode).


## Usage

This is a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
``` 


### Format

Format the contracts:

```sh
$ forge fmt
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

We welcome contributions from the community to help improve the Diamond Foundry.

## License
MIT License (c) 2023 Forgenie Labs

## Acknowledgements

Nick Mudge @mudgen [diamond-hardhat](https://github.com/mudgen/diamond)  
Paul Razvan Berg @PaulRBerg [foundry-template](https://github.com/PaulRBerg/foundry-template)

