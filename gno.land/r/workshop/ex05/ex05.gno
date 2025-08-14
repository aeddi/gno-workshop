package ex05

func Render(_ string) string {
	return `# Exercise 05:

## Routing Render to Different Pages

In previous exercises, we've seen simple Render functions that return basic content. But what if we want our realm to handle multiple pages or path parameters? This is what we'll explore in this exercise.

The **path parameter** in your Render function is the key to routing in Gno. When someone visits ` + "`/r/myrealm:<path>`" + `, the ` + "`<path>`" + ` part is passed to your Render function as the path parameter.

For example:
- ` + "`/r/myrealm`" + ` → path = ` + "`\"\"`" + ` (empty string)
- ` + "`/r/myrealm:home`" + ` → path = ` + "`\"home\"`" + `
- ` + "`/r/myrealm:user/alice`" + ` → path = ` + "`\"user/alice\"`" + `
- ` + "`/r/myrealm:posts/123?q=test`" + ` → path = ` + "`\"posts/123?q=test\"`" + `

## The ` + "`gno.land/p/demo/mux`" + ` Package

To handle complex routing, the ` + "`mux`" + ` package can certainly help. It provides a simple way to:
- Register multiple route handlers
- Capture path parts as variables (e.g., get the ` + "`username`" + ` in ` + "`/user/{username}`" + `)
- Parse query parameters (e.g., ` + "`?q=test`" + `)

Let's build a simple router realm to demonstrate these capabilities!

## Step-by-Step Implementation

### Step 1: Create the Router Realm

Create ` + "`gno.land/r/router/router.gno`" + ` file with the following content:

` + "```go" + `
package router

import (
	"gno.land/p/demo/mux"
	"gno.land/p/demo/ufmt"
)

var router *mux.Router

func init() {
	router = mux.NewRouter()

	// Homepage route
	router.HandleFunc("", homepageHandler)

	// User profile route: /r/router:user/alice
	router.HandleFunc("user/{name}", userHandler)

	// Post route with ID: /r/router:post/123
	router.HandleFunc("post/{id}", postHandler)

	// Search with query params: /r/router:search?q=golang
	router.HandleFunc("search", searchHandler)

	// About page: /r/router:about
	router.HandleFunc("about", aboutHandler)
}

func Render(path string) string {
	return router.Render(path)
}

// Handler functions
func homepageHandler(res *mux.ResponseWriter, req *mux.Request) {
	res.Write("# Welcome to Router Demo\n\n")
	res.Write("This realm demonstrates the mux package for routing.\n\n")
	res.Write("## Available Pages\n")
	res.Write("- [About](/r/router:about)\n")
	res.Write("- [User Profile: Alice](/r/router:user/alice)\n")
	res.Write("- [User Profile: Bob](/r/router:user/bob)\n")
	res.Write("- [Post 1](/r/router:post/1)\n")
	res.Write("- [Post 42](/r/router:post/42)\n")
	res.Write("- [Search for 'gno'](/r/router:search?q=gno)\n")
	res.Write("- [Search for 'blockchain'](/r/router:search?q=blockchain)\n")
}

func userHandler(res *mux.ResponseWriter, req *mux.Request) {
	name := req.GetVar("name")

	res.Write(ufmt.Sprintf("# User Profile: %s\n\n", name))
	res.Write(ufmt.Sprintf("Welcome to %s's profile page!\n\n", name))
	res.Write("This demonstrates path variables in routing.\n\n")
	res.Write("[← Back to homepage](/r/router)")
}

func postHandler(res *mux.ResponseWriter, req *mux.Request) {
	id := req.GetVar("id")

	res.Write(ufmt.Sprintf("# Post #%s\n\n", id))
	res.Write(ufmt.Sprintf("You are viewing post number %s.\n\n", id))
	res.Write("This shows how to capture numeric IDs from URLs.\n\n")
	res.Write("[← Back to homepage](/r/router)")
}

func searchHandler(res *mux.ResponseWriter, req *mux.Request) {
	query := req.Query.Get("q")

	res.Write("# Search Results\n\n")

	if query == "" {
		res.Write("Please provide a search query using ` + "`?q=searchterm`" + `\n\n")
	} else {
		res.Write(ufmt.Sprintf("You searched for: **%s**\n\n", query))
		res.Write("This demonstrates query parameter parsing.\n\n")
	}

	res.Write("[← Back to homepage](/r/router)")
}

func aboutHandler(res *mux.ResponseWriter, req *mux.Request) {
	res.Write("# About This Router\n\n")
	res.Write("This realm demonstrates the mux package capabilities:\n\n")
	res.Write("- **Static routes**: Like this about page\n")
	res.Write("- **Variable routes**: Capturing parts of the URL path\n")
	res.Write("- **Query parameters**: Getting data from URL parameters\n\n")
	res.Write("[← Back to homepage](/r/router)")
}
` + "```" + `

### Step 2: Create the gnomod File

Create ` + "`gno.land/r/router/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/r/router"
gno = "0.9"
` + "```" + `

### Step 3: Test by Visiting the Page

After creating these files, test your routing by visiting these URLs:

1. **Homepage**: [/r/router](/r/router)
   - Should show the welcome page with links to all other pages

2. **Static Route**: [/r/router:about](/r/router:about)
   - Shows information about the router capabilities

3. **User Profile Routes** (path variables):
   - [/r/router:user/alice](/r/router:user/alice) - Alice's profile
   - [/r/router:user/bob](/r/router:user/bob) - Bob's profile
   - [/r/router:user/charlie](/r/router:user/charlie) - Charlie's profile

4. **Post Routes** (numeric path variables):
   - [/r/router:post/1](/r/router:post/1) - Post #1
   - [/r/router:post/42](/r/router:post/42) - Post #42
   - [/r/router:post/999](/r/router:post/999) - Post #999

5. **Search with Query Parameters**:
   - [/r/router:search?q=gno](/r/router:search?q=gno) - Search for "gno"
   - [/r/router:search?q=blockchain](/r/router:search?q=blockchain) - Search for "blockchain"
   - [/r/router:search](/r/router:search) - Search without query parameter

Each page should display the appropriate content and demonstrate the different routing features.

### Step 4: Run Tests

Run the tests with:

` + "```bash" + `
cd gno.land/r/router
gno test -v ./...
` + "```" + `

All tests should pass, demonstrating that your routing works correctly.

## Key Takeaways

By completing this exercise, you've learned:

- **Path parameter**: Understanding Gno Realm Render path parameter format (` + "`/r/realm:path?query=value`" + `)
- **The mux Package**: How to use ` + "`gno.land/p/demo/mux`" + ` for advanced routing in Gno realms
  - **Route Types**:
    - Static routes (` + "`\"about\"`" + `) for fixed paths
    - Variable routes (` + "`\"user/{name}\"`" + `) for capturing path segments
  - **Path Variables**: Using ` + "`req.GetVar(\"name\")`" + ` to extract URL parameters
  - **Query Parameters**: Using ` + "`req.Query.Get(\"q\")`" + ` to read query string values

This routing system enables you to create web-like navigation experiences in your Gno realms, making them more interactive and user-friendly!

**Next Steps:** [Continue to Exercise 06](/r/workshop/ex06)
`
}
