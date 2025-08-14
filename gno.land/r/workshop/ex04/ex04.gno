package ex04

func Render(_ string) string {
	return `# Exercise 04:

## Introduction to Gno Pure Packages

In this exercise, we'll explore **pure packages** in Gno. Remember, pure packages are stateless libraries that provide reusable functions and types. They don't maintain any persistent state like realms do.

We will write a simple markdown package and import it into a realm. Then we'll take a look at some existing packages in the Gno ecosystem.

## Part 1: Building a Markdown Package

Let's create a simple markdown generation package that other realms can use to format their output.

### Step 1: Create the Pure Package

Create ` + "`gno.land/p/markdown/markdown.gno`" + `:

` + "```go" + `
package markdown

import "strconv"

// H1 creates a level 1 heading
func H1(text string) string {
	return "# " + text + "\n\n"
}

// H2 creates a level 2 heading
func H2(text string) string {
	return "## " + text + "\n\n"
}

// H3 creates a level 3 heading
func H3(text string) string {
	return "### " + text + "\n\n"
}

// Paragraph creates a paragraph
func Paragraph(text string) string {
  return text + "\n\n"
}

// BulletList creates a bulleted list from a slice of items
func BulletList(items []string) string {
	var result string
	for _, item := range items {
		result += "- " + item + "\n"
	}
	return result + "\n"
}

// OrderedList creates a numbered list from a slice of items
func OrderedList(items []string) string {
	var result string
	for i, item := range items {
		result += strconv.Itoa(i+1) + ". " + item + "\n"
	}
	return result + "\n"
}
` + "```" + `

### Step 2: Create the gnomod File

Create ` + "`gno.land/p/markdown/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/p/markdown"
gno = "0.9"
` + "```" + `

### Step 3: Create the Demo Realm

Now let's create a realm that demonstrates our markdown package.

Create ` + "`gno.land/r/markdown/markdown.gno`" + `:

` + "```go" + `
package markdown

import "gno.land/p/markdown"

func Render(_ string) string {
	out := markdown.H1("Welcome to the Markdown Realm")
	out += markdown.Paragraph("This realm demonstrates the usage of a markdown pure package.")

	out += markdown.H2("Features")
	out += markdown.BulletList([]string{
		"Create headings at different levels",
		"Format paragraphs",
		"Generate bullet and ordered lists",
	})

	out += markdown.H2("How to Use")
	out += markdown.OrderedList([]string{
		"Create a realm or pure package",
		"Import the markdown package",
		"Call markdown package functions to format your content",
	})

  return out
}
` + "```" + `

### Step 4: Create the gnomod File for the Realm

Create ` + "`gno.land/r/markdown/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/r/markdown"
gno = "0.9"
` + "```" + `

### Step 5: Test Both the Package and Realm

Now you can visit [/r/markdown](/r/markdown) realm to see the rendered markdown output.

## Part 2: Useful Community Packages Overview

A more feature-complete Markdown package already exists at [gno.land/p/moul/md](https://github.com/gnolang/gno/tree/master/examples/gno.land/p/moul/md) including additional features like: tables, links, text formatting (bold, italic, strikethrough), code blocks, and more.

The Gno ecosystem has many useful packages created by the community:

- [/p/demo/ufmt](/p/demo/ufmt): String formatting utilities (similar to Go's fmt package)
- [/p/demo/uassert](/p/demo/uassert): Helpers for testing (similar to Go's testify package)
- [/p/demo/avl](/p/demo/avl): Balanced binary search tree implementation
- [/p/demo/mux](/p/demo/mux): Routing utilities for realms Render functions
- [/p/demo/ownable](/p/demo/ownable): Ownership management for data storage in realms

### Finding More Packages

You can find a curated list of available packages in our [GitHub repository](https://github.com/gnolang/gno/tree/master/examples/gno.land)

Explore the ` + "`/p`" + ` directory to discover pure packages you can import in your own projects!

## Key Takeaways

- **Pure Packages**: Stateless libraries that provide reusable functions and types
- **Community Packages**: Many useful packages are available in the Gno ecosystem

**Next Steps:** [Continue to Exercise 05](/r/workshop/ex05)
`
}
