# Diamond Foundry

Welcome to the Diamond Foundry project! This repository introduces a robust system that simplifies smart contract
management using the EIP2535 Diamond Proxy Standard, a specification for an upgradable smart contract on Ethereum
blockchain.

The primary goal is to build a versatile and reusable library of smart contract facets and an automated Diamond Factory.
This system offers a solution to common challenges associated with smart contract development and deployment, such as
complexity and the requirement for skilled engineers and auditors.

Please note that the project is still a work in progress. While we strive for accuracy, the software is provided "as
is", and users are urged to use it with discretion as it's not yet stable for production environments.

## Features

1. Facet Registry and Diamond Factory.
1. Linting, Build, Test & Slither in CI. Deployment of artifacts to be added.
1. Multi address delegate call and Facets containing built-in initializers.
1. `DiamondCutFacet` and `DiamondLoupeFacet` implementation.
1. Simple `OwnableFacet` and `Ownable2StepFacet` with pending owner functionality.
1. `NFTOwnershipFacet`, where ownership is attributed to a NFT.
1. `AccessControlFacet`, optimized access control with 256 roles.

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

- Use diamond storage `Layout` pattern for storing variables in file named `<FacetName>Storage`.
- Define internal behavior, interact with storage in the `<FacetName>Base` abstract contract.
- Compose initializer and protect external calls in `<FacetName>Facet` contract.
- `I<FacetName>` for interface of external functions, and `I<FacetName>Base` for errors, structs, enums, and events.

2. Testing

- Build helper contract named `<FacetName>Helper` for getting facet's selectors, initalizer and supported interfaces.
- Attach facet interface to a diamond's address in the `setUp` of an `abstract <FacetName>FacetTest` contract. Override
  `diamondInitParams()` to initialize diamond with tested facet or others if needed.
- Reuse `I<Facet>Base` interface for accessing internal structs, errors, events or enums.
- Test facets by attaching their `interface` to a diamond address.
- There is one `Test` contract per each function within a Facet. It's naming should follow the `<Contract>_<method>`
  rule, so that we can isolate it with `--match-contract <REGEX>`.

## License

MIT License (c) 2023 Forgenie Labs

## Acknowledgements

Nick Mudge @mudgen [diamond-hardhat](https://github.com/mudgen/diamond)<br /> Paul Razvan Berg @PaulRBerg
[foundry-template](https://github.com/PaulRBerg/foundry-template) <br /> OpenZeppelin @OpenZeppelin
[openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
