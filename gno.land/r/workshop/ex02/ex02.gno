package ex02

func Render(_ string) string {
	return `# Exercise 02

## State Management in Gno Realms

Before diving into state management, let's understand the key difference between realms and packages in Gno:

- **Pure Packages (` + "`gno.land/p/...`" + `)**: Stateless libraries that provide reusable functions and types. They don't maintain any persistent state.
- **Realms (` + "`gno.land/r/...`" + `)**: Stateful smart contracts that can store and persist data on the blockchain. Each realm maintains its own state across function calls.

Think of packages as utility libraries, while realms are like persistent applications that can remember their state. For more details, see the dedicated [Gno documentation](https://docs.gno.land/resources/gno-packages/#package-types).

## Part 1: Basic Counter with State Persistence

Let's start with a simple counter that demonstrates state persistence.

### Step 1: Create the Basic Counter Realm

Create a file at ` + "`gno.land/r/hellocounter/v1/hellocounter.gno`" + ` with the following content:

` + "```go" + `
package hellocounter

import "strconv"

var counter int

func Render(_ string) string {
    return "Hello World! Counter: " + strconv.Itoa(counter)
}

func Increment(cur realm) {
    counter++
}
` + "```" + `

### Step 2: Create the gnomod File

Create a ` + "`gnomod.toml`" + ` file in the same folder:

` + "```toml" + `
module = "gno.land/r/hellocounter/v1"
gno = "0.9"
` + "```" + `

### Step 3: Understanding Crossing Functions

The ` + "`Increment`" + ` function includes a ` + "`cur realm`" + ` parameter. This makes it a **crossing function** that can modify realm state:

- **Security**: Only authenticated transactions can call crossing functions
- **Context**: Provides access to the current execution context
- **Permission**: Grants ability to modify the realm's state

Functions without ` + "`cur realm`" + ` (like ` + "`Render`" + `) are read-only and cannot modify state. For more details, see the [Interrealm Specification](https://docs.gno.land/resources/gno-interrealm#introduction).

### Step 4: Testing with Accounts and Transactions

To interact with your realm and call the ` + "`Increment`" + ` function, you need to understand that **realms require authenticated transactions**.

Simply put, an **account** is a keypair (public key + private key) that identifies you on the blockchain. When you make a transaction, you sign it with your private key to prove your identity.

Our dedicated command line tool ` + "`gnokey`" + ` helps you manage accounts and make transactions. More details can be found [here](https://docs.gno.land/users/interact-with-gnokey).

#### Create an Account

First, create a test account using ` + "`gnokey`" + `:

` + "```bash" + `
gnokey add testuser
` + "```" + `

This will generate a new keypair and ask you to set a password (we recommend a blank password for simplicity in this tutorial).

> [!WARNING]
> Then **restart ` + "`gnodev`" + `** to ensure it recognizes your new account and automatically funds it with test tokens.

#### Call the Increment Function

Now you can call the ` + "`Increment`" + ` function using a transaction:

` + "```bash" + `
gnokey maketx call \
    -pkgpath "gno.land/r/hellocounter/v1" \
    -func "Increment" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser
` + "```" + `

After calling this command:
1. Visit [/r/hellocounter/v1](/r/hellocounter/v1) to see the counter has increased
2. The state persists on the blockchain - reload the page and the counter value remains!

#### Try It Yourself

You can now add ` + "`Decrement`" + ` and ` + "`Reset`" + ` functions to your realm and test them:

` + "```go" + `
func Decrement(cur realm) {
    counter--
}

func Reset(cur realm) {
    counter = 0
}
` + "```" + `

Test these functions using similar ` + "`gnokey maketx call`" + ` commands, just change the ` + "`-func`" + ` parameter.

---

## Part 2: Adding Dynamic Names

Now let's extend our realm to support personalized greetings.

### Step 1: Initialize the V2

We copied your previous work ` + "`hellocounter.gno`" + ` to the folder ` + "`gno.land/r/hellocounter/v2`" + `.

Then add the ` + "`gnomod.toml`" + ` in the v2 folder:

` + "```toml" + `
module = "gno.land/r/hellocounter/v2"
gno = "0.9"
` + "```" + `

### Step 2: Add Name State
So far, our realm has a static greeting. Let's modify it to allow dynamic names.

Add a name variable to your realm:

` + "```go" + `
var (
    counter int
    name    string = "World"
)
` + "```" + `

### Step 3: Add SetName Function

Add a function to update the name:

` + "```go" + `
func SetName(cur realm, newName string) {
    name = newName
}
` + "```" + `

### Step 4: Update Render Function

Modify the render function to use the dynamic name:

` + "```go" + `
func Render(_ string) string {
    return "Hello, " + name + "! Counter: " + strconv.Itoa(counter)
}
` + "```" + `

### Step 5: Calling Functions with Arguments

To call ` + "`SetName`" + ` with a parameter, use the ` + "`-args`" + ` flag:

` + "```bash" + `
gnokey maketx call \
    -pkgpath "gno.land/r/hellocounter/v2" \
    -func "SetName" \
    -args <YOUR_NAME> \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser
` + "```" + `

> [!NOTE]
> Replace <YOUR_NAME> with the name you want to set, e.g., ` + "`Alice`" + `.

After running this command, [visit your realm](/r/hellocounter/v2) and you should see "Hello, <YOUR_NAME>! Counter: X"


#### Expected Behavior

- **Initial render**: "Hello, World! Counter: 0"
- **After calling Increment() twice**: "Hello, World! Counter: 2"
- **After calling SetName("Bob")**: "Hello, Bob! Counter: 2"
- **After calling Reset()**: "Hello, Bob! Counter: 0"

### Step 5: Test Your Realm

Run the tests provided in ` + "`hellocounter_test.gno`" + ` to ensure everything works as expected:

` + "```bash" + `
cd gno.land/r/hellocounter/v2
gno test -v ./...
` + "```" + `


## Key Takeaways

By completing this exercise, you've learned:

- The difference between stateless packages and stateful realms
- How global variables in realms persist on the blockchain
- The role of crossing functions with ` + "`cur realm`" + ` parameters
- How to create accounts and make transactions using ` + "`gnokey`" + `
- How to call functions with arguments using the ` + "`-args`" + ` flag
- The fundamental patterns of interactive Gno realm development

Your realm now demonstrates the core concepts of state management in Gno!

**Next Steps:** [Continue to Exercise 03](/r/workshop/ex03)
`
}
