package ex06

func Render(_ string) string {
	return `# Exercise 06:

## Storing and Retrieving Data Efficiently

In Gnoland, you might initially think to use Go's built-in ` + "`map`" + ` type for storing data. However, there's a fundamental rule in Gno development: **"use AVL trees, not maps"**. But why?

### Why AVL Trees Over Maps?

Loading a map loads the entire dataset into memory, which is not feasible for multi-gigabyte data stores; an AVL tree stores data as separate objects, enabling scalable storage and retrieval without forcing full in-memory loading.

More info on this [here](https://gno.howl.moe/avl-tree-storage/).

### AVL Tree Packages in Gno

Gno provides several AVL-based packages for different use cases:

- **` + "`gno.land/p/demo/avl`" + `**: Core AVL tree implementation for key-value storage
- **` + "`gno.land/p/demo/avl/list`" + `**: AVL-based list for ordered collections
- **` + "`gno.land/p/demo/avl/pager`" + `**: Pagination utilities for AVL structures

In this exercise, we'll use ` + "`avl.list`" + ` to store users and ` + "`avl.pager`" + ` to display them in a paginated format.

## Creating a Userbase

### Step 1: Create the Userbase Realm

Create ` + "`gno.land/r/userbase/userbase.gno`" + ` file with the following content:

` + "```go" + `
package userbase

import (
	"gno.land/p/demo/avl/list"
	p "gno.land/p/demo/avl/pager"
	"gno.land/p/demo/faker"
	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/md"
)

type User struct {
	ID      int
	Name    string
	Age     int
	Country string
}

var (
	users list.List
	pager = p.NewPager(users.Tree(), 20, false) // Default page size is 20
)

func init() {
	// Generate 100 fake users during realm initialization
	for i := 1; i <= 100; i++ {
		user := User{
			ID:      i,
			Name:    faker.FullName(),
			Age:     faker.Age(18),
			Country: faker.Country(),
		}
		users.Append(user)
	}
}

func Render(path string) string {
	out := md.H1("Userbase Demo Realm")
	out += md.Paragraph("This realm demonstrates a simple userbase with pagination using an AVL list and an AVL pager.")
	out += md.H2(ufmt.Sprintf("User List (total %d):", users.Len()))

	// Get the page by path or panic
	page := pager.MustGetPageByPath(path)

	// Append user details to  list
	for _, item := range page.Items {
		user := item.Value.(User)
		out += ufmt.Sprintf("- %s, %s, %s, %s\n",
			md.Bold(ufmt.Sprintf("ID: %d", user.ID)),
			md.Italic(user.Name),
			ufmt.Sprintf("Age: %d", user.Age),
			ufmt.Sprintf("Country: %s", user.Country),
		)
	}
	out += "\n"

	// Add pagination controls
	out += page.Picker(path)

	return out
}
` + "```" + `

### Step 2: Create the gnomod File

Create ` + "`gno.land/r/userbase/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/r/userbase"
gno = "0.9"
` + "```" + `

### Step 3: Test your Userbase

After creating these files, visit [r/userbase](/r/userbase) to see the paginated user list.

Use the pagination controls to navigate through the user list.

## Key Takeaways

By completing this exercise, you've learned:

- **AVL Trees vs Maps**: Why AVL trees are preferred in Gnoland for scalability and gas efficiency
- **AVL List Usage**: How to use ` + "`gno.land/p/demo/avl/list`" + ` for ordered collections
- **AVL Pager Usage**: How to use ` + "`gno.land/p/demo/avl/pager`" + ` for pagination

This approach enables you to build scalable, gas-efficient applications that can handle large datasets while providing excellent user experience through pagination!

**Next Steps:** [Continue to Exercise 07](/r/workshop/ex07)
`
}
