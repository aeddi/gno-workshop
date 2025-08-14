package ex06

func Render(_ string) string {
	return `# Exercise 07:

## Putting It All Together: Let's Build a Forum

In this exercise, we will combine everything we've learned so far to build a simple forum application.

The forum will allow users to:
- Register as members
- Create threads
- Post replies
- Delete (only) their own threads and posts

The data will be stored using AVL trees for efficient retrieval and pagination.

Finally, a router will be used to handle different pages.

### Step 1: Create the Forum Realm

Create ` + "`gno.land/r/forum/forum.gno`" + `:

` + "```go" + `
package forum

import (
	"math/rand"
	"std"
	"strconv"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/avl/list"
	p "gno.land/p/demo/avl/pager"
	"gno.land/p/demo/faker"
	"gno.land/p/demo/mux"
	"gno.land/p/moul/md"
)

type Thread struct {
	ID      int
	Title   string
	Content string
	Author  std.Address
	Posts   list.List
}

type Post struct {
	ID      int
	Content string
	Author  std.Address
}

var (
	router       = mux.NewRouter()
	threads      = list.List{} // List of threads
	threadsPager = p.NewPager(threads.Tree(), 10, false)
	members      = avl.Tree{} // std.Address -> Username mapping
)

// RegisterMember registers a new member with a username.
func RegisterMember(_ realm, username string) {
	caller := std.PreviousRealm()
	members.Set(caller.Address().String(), username)
}

// CreateThread creates a new thread with the given title and content.
// It requires the caller to be a registered member.
// Returns the ID of the created thread.
func CreateThread(_ realm, title, content string) int {
	if title == "" || content == "" {
		panic("title and content cannot be empty")
	}

	caller := std.PreviousRealm()
	if !members.Has(caller.Address().String()) {
		panic("you need to register as a member first")
	}

	threadID := threads.Len() // Simple ID generation

	// Create a new thread and append it to the threads list
	thread := &Thread{
		ID:     threadID,
		Title:  title,
		Author: caller.Address(),
		Posts:  list.List{},
	}
	threads.Append(thread)

	return threadID
}

// DeleteThread deletes a thread by its ID.
// It requires the caller to be the author of the thread.
func DeleteThread(_ realm, threadID int) {
	thread := mustGetThread(threadID)

	caller := std.PreviousRealm()
	if thread.Author != caller.Address() {
		panic("you can only delete threads you created")
	}

	threads.Delete(threadID)
}

// CreatePost creates a new post in the specified thread.
// It requires the caller to be a registered member.
// Returns the ID of the created post.
func CreatePost(_ realm, threadID int, content string) int {
	if content == "" {
		panic("content cannot be empty")
	}

	caller := std.PreviousRealm()
	if !members.Has(caller.Address().String()) {
		panic("you need to register as a member first")
	}

	thread := mustGetThread(threadID)
	postID := thread.Posts.Len() // Simple ID generation

	// Create a new post and append it to the thread's posts list
	post := &Post{
		ID:      postID,
		Content: content,
		Author:  caller.Address(),
	}
	thread.Posts.Append(post)

	return postID
}

// DeletePost deletes a post from a thread by its ID.
// It requires the caller to be the author of the post.
func DeletePost(_ realm, threadID, postID int) {
	thread := mustGetThread(threadID)
	post := mustGetPost(thread, postID)

	caller := std.PreviousRealm()
	if post.Author != caller.Address() {
		panic("you can only delete posts you created")
	}

	thread.Posts.Delete(postID)
}

func Render(path string) string {
	out := md.H1("My Awesome Gno Forum")
	out += router.Render(path)
	return out
}

func homepageHandler(res *mux.ResponseWriter, req *mux.Request) {
	out := md.H2("Thread list (total " + strconv.Itoa(threads.Len()) + ")")

	// Get the page of posts from the path
	page := threadsPager.MustGetPageByPath(req.Path)

	for _, item := range page.Items {
		thread := item.Value.(*Thread)
		out += md.H3(md.Link("Thread: "+thread.Title, "/r/forum:thread/"+strconv.Itoa(thread.ID)))
		out += md.Paragraph("Created by " + md.Bold(mustGetMemberUsername(thread.Author)))
		out += md.Paragraph("Total posts: " + strconv.Itoa(thread.Posts.Len()))
		out += md.HorizontalRule()
	}

	// Add pagination controls
	out += page.Picker(req.RawPath)

	res.Write(out)
}

func threadHandler(res *mux.ResponseWriter, req *mux.Request) {
	// Extract thread ID from the request path
	id := req.GetVar("id")
	threadID, err := strconv.Atoi(id)
	if err != nil {
		panic("invalid thread ID" + err.Error())
	}

	// Get the thread and init a post pager with it
	thread := mustGetThread(threadID)
	postPager := p.NewPager(thread.Posts.Tree(), 10, false)

	// Get the page of posts from the path
	page := postPager.MustGetPageByPath(req.Path)

	out := md.H2("Thread: " + thread.Title)
	out += md.Paragraph("Created by " + md.Bold(mustGetMemberUsername(thread.Author)))
	out += md.HorizontalRule()

	// Render each post
	for _, item := range page.Items {
		post := item.Value.(*Post)
		out += md.H3("Post by " + md.Bold(mustGetMemberUsername(post.Author)))
		out += md.Paragraph(post.Content)
		out += md.HorizontalRule()
	}
	out += "\n"

	// Add pagination controls
	out += page.Picker(req.RawPath)

	res.Write(out)
}

func mustGetMemberUsername(addr std.Address) string {
	username, ok := members.Get(addr.String())
	if !ok {
		panic("no member found, you need to register first")
	}
	return username.(string)
}

func mustGetThread(threadID int) *Thread {
	thread := threads.Get(threadID)
	if thread == nil {
		panic("thread not found")
	}
	return thread.(*Thread)
}

func mustGetPost(thread *Thread, postID int) *Post {
	post := thread.Posts.Get(postID)
	if post == nil {
		panic("post not found")
	}
	return post.(*Post)
}

// init initializes the router and generates some example data.
func init() {
	router.HandleFunc("", homepageHandler)
	router.HandleFunc("thread/{id}", threadHandler)

	// Example data
	// Create 30 members
	for i := 0; i < 30; i++ {
		members.Set(faker.Address(), faker.Username())
	}

	// Create between 0 and 5 threads by member
	rng := rand.New(rand.NewPCG(42, 0xdeadbeef))
	threadCount := rng.IntN(3)

	members.IterateByOffset(0, members.Size(), func(addr string, username interface{}) bool {
		for i := 0; i < threadCount; i++ {
			thread := &Thread{
				ID:     threads.Len(),
				Title:  faker.LoremSentence(),
				Author: std.Address(addr),
				Posts:  list.List{},
			}
			threads.Append(thread)

			// Create between 5 and 25 posts in each thread
			postCount := rng.IntN(20) + 5
			for i := 0; i < postCount; i++ {
				randomAddr, _ := members.GetByIndex(rng.IntN(members.Size()))
				post := &Post{
					ID:      thread.Posts.Len(),
					Content: faker.LoremParagraph(),
					Author:  std.Address(randomAddr),
				}
				thread.Posts.Append(post)
			}
		}
		return false
	})

}
` + "```" + `

### Step 2: Create the gnomod File

Create ` + "`gno.land/r/forum/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/r/forum"
gno = "0.9"
` + "```" + `

### Step 3: Test your Forum

To test your forum, you can run first visit it at [r/forum](/r/forum) and explore the demo threads and posts generated in the init function.

### Step 4: Interact with the Forum using transactions

We recommend you to interact with the forum using transactions:

1. Create multiple accounts using ` + "`gnokey`" + `
2. Register them as a members using ` + "`RegisterMember`" + ` with an username
3. Create threads using ` + "`CreateThread`" + ` with a title and content
4. Create posts in threads using ` + "`CreatePost`" + ` with the thread
5. Try to delete threads and posts using ` + "`DeleteThread`" + ` and ` + "`DeletePost`" + `. If you try to delete a thread or post that you didn't create, it will panic.
`
}
