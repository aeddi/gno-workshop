package ex01

func Render(_ string) string {
	return `# Exercise 01

## Introduction to Gno Realms

Welcome to your first Gno development exercise! This will introduce you to the fundamental concepts of Gno realms.

## What is a Gno Realm?

A Gno realm is the entry point for any Gno application. It is a smart-contract stored on the blockchain that can hold state, execute logic, and render content through the ` + "`Render`" + ` function.

## The Render Function

Every Gno realm must have a ` + "`Render`" + ` function with this signature:
` + "```go" + `
func Render(path string) string
` + "```" + `

The ` + "`path`" + ` parameter allows for routing different URLs within your realm (more on this in later exercises).
The function returns a string containing Markdown that will be rendered as HTML on the Gnoweb interface.

## Your First Gno Realm

Create your first Gno realm by completing these steps:

### Step 1: Create the Realm File

Create a file at ` + "`gno.land/r/hello/hello.gno`" + ` with the following content:

` + "```go" + `
package hello

func Render(path string) string {
	out := "# Hello, Gno World!\n"
	out += "Welcome to my first realm!"
	return out
}
` + "```" + `

### Step 2: Create the gnomod File

You need to initialize a Gno module for your realm. This can be done automatically by running the following command in your terminal:

` + "```sh" + `
cd gno.land/r/hello
gno mod init gno.land/r/hello
` + "```" + `

Or you can manually create a file at ` + "`gno.land/r/hello/gnomod.toml`" + ` with the following content:

` + "```toml" + `
module = "gno.land/r/hello"
gno = "0.9"
` + "```" + `

### Step 3: Render Your Realm

After creating these files, visit: [/r/hello](/r/hello)

On this page, you should see the content rendered from your ` + "`Render`" + ` function.
You can also view the source code of your realm by clicking the "Source" button in the top right corner.

### Step 4: Test Your Realm

To ensure your realm works correctly, we provide a test suite. You can run the tests by executing the following command in your terminal:

` + "```sh" + `
cd gno.land/r/hello
gno test -v ./...
` + "```" + `

This will run the tests defined in ` + "`hello_test.gno`" + `, which should pass if your realm is set up correctly.

## Key Takeaways

By completing this exercise, you've learned:
- What a Gno realm is
- The purpose of the ` + "`Render`" + ` function
- How to create a Gno realm and its module

**Next Steps:** [Continue to Exercise 02](/r/workshop/ex02)
`
}
