package home

func Render(_ string) string {
	const setupRepo = "https://github.com/aeddi/gno-workshop"

	return `# Welcome to Gno Workshop

This workshop is designed to help you master the **Gno** programming language through **a series of hands-on exercises**.

Gno combines the simplicity of **Go with blockchain capabilities**, offering a unique platform for building **decentralized applications** with familiar syntax and powerful features.

You're currently viewing this content through **Gnoweb - the web interface** for the Gno blockchain. What you're seeing is not a static website, but rather the web representation of a Realm (smart contract) **dynamically rendered by a Gnoland node**.

Whether you're new to blockchain development or transitioning from Go, these tutorials will guide you through Gno's core concepts, from basic syntax to advanced Realm development.

## Getting Started

To begin your journey with Gno, you first need to **set up your environment**. Follow the steps listed on our [dedicated repo](` + setupRepo + `).

Once your environment is set up, review the list of [exercises](/r/workshop/home#exercises) below and follow the instructions provided. **We recommend progressing sequentially**, as each exercise builds on previous concepts and is designed to help you understand various aspects of the Gno programming language.

For more in-depth information, refer to the [official documentation](https://docs.gno.land).

## Exercises

1. [Introduction to Gno Realms](/r/workshop/ex01)
2. [State Management in Gno Realms](/r/workshop/ex02)
3. [Caller Authentication and Permission](/r/workshop/ex03)
4. [Introduction to Gno Pure Packages](/r/workshop/ex04)
5. [Routing Render to Different Pages](/r/workshop/ex05)
6. [Storing and Retrieving Data Efficiently](/r/workshop/ex06)
7. [Putting It All Together: Let's Build a Forum](/r/workshop/ex07)


---

## Explore Packages and Realms

All code in Gno.land is **organized in packages**, and each package lives at a unique package path like ` + "`r/gnoland/home`" + `. You can browse packages, inspect their source, and **use them** in your own libraries and realms.

<gno-columns>

### r/gnoland

Official realm packages developed by the core team.

[-> Browse](/r/gnoland)

|||

### r/demo

Demo realm packages showcasing what’s possible.

[-> Browse](/r/demo)

|||

### p/demo

Pure packages including utilities and demonstrations.

[-> Browse](/p/demo)

</gno-columns>

<gno-columns>

## Ecosystem

- [Gnoverse](https://github.com/gnoverse)
- [Gnoscan](https://gnoscan.io)
- [Adena Wallet](https://www.adena.app)
- [Faucet Hub](https://faucet.gno.land)
- [Gno.love](https://gnolove.world)

|||

## Socials

- [Discord](https://discord.gg/S8nKUqwkPn)
- [Twitter](https://twitter.com/_gnoland)
- [Youtube](https://www.youtube.com/@_gnoland)
- [Telegram](https://t.me/gnoland)
- [GitHub Discussions](https://github.com/gnolang/gno/discussions)

|||

## About

- [Homepage](https://gno.land)
- [Documentation](https://docs.gno.land)
- [GitHub](https://github.com/gnolang)
- [Partners, Fund, Grants](/partners)
- [Careers](https://jobs.ashbyhq.com/allinbits)

</gno-columns>
`
}
