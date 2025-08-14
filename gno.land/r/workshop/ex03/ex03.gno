package ex03

func Render(_ string) string {
	return `# Exercise 03

## Caller Authentication and Permission

In Gno, realms can authenticate both **user calls** and **realm calls**. This exercise teaches you how to implement permission systems using caller authentication.

More details about the difference between user (EOA) and realm calls can be found in the [Gno documentation](https://docs.gno.land/resources/realms#smart-contract-realms).

## Key Concepts

- **User Authentication**: Verify that the caller is an actual user (not another realm)
- **Realm Authentication**: Check if the calling realm has the expected package path
- **Panic Usage**: In Gno, we use ` + "`panic`" + ` as a control flow mechanism to immediately halt execution when authentication fails. This ensures transactions are rolled back and no state changes are persisted. [Learn more about panic in Gno](https://docs.gno.land/resources/effective-gno/#embrace-panic).

## Part 1: User Authentication

First, we'll create a realm that demonstrates user authentication patterns by allowing users to claim ownership and transfer it.

### Step 1: Create the Callee Realm

Create the ` + "`gno.land/r/auth/callee/callee.gno`" + ` file:

` + "```go" + `
package callee

import "std"

var owner std.Address

func Claim(cur realm) {
	if owner != "" {
		panic("owner already set")
	}

	caller := std.PreviousRealm()
	owner = caller.Address()
}

func TransferOwnership(cur realm, newOwner std.Address) {
	if owner == "" {
		panic("no owner set")
	}

	// Verify the caller is the current owner
	caller := std.PreviousRealm()
	if caller.Address() != owner {
		panic("only owner can transfer ownership")
	}

	if !newOwner.IsValid() {
		panic("invalid address")
	}

	owner = newOwner
}

func Render(_ string) string {
	out := "# Callee Realm\n"

	if owner == "" {
		out += "No owner set yet."
	} else {
		out += "Current owner: " + owner.String()
	}

	return out
}
` + "```" + `

### Step 2: Create the gnomod File for Callee

Create ` + "`gno.land/r/auth/callee/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/r/auth/callee"
gno = "0.9"
` + "```" + `

### Step 3: Test User Authentication

First, create a test account and claim ownership:

` + "```bash" + `
# Restart gnodev to fund the account
# Then claim ownership
gnokey maketx call \
    -pkgpath "gno.land/r/auth/callee" \
    -func "Claim" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser
` + "```" + `

Visit [/r/auth/callee](/r/auth/callee) to see that ownership has been claimed.

Try calling ` + "`Claim`" + ` again - it should fail with "owner already set".

### Step 4: Test Ownership Transfer

Create another test account and transfer ownership:

` + "```bash" + `
# Create another account
gnokey add testuser2

# Get the address of testuser2
gnokey list

# Transfer ownership (replace ADDRESS with testuser2's actual address)
gnokey maketx call \
    -pkgpath "gno.land/r/auth/callee" \
    -func "TransferOwnership" \
    -args "ADDRESS" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser
` + "```" + `

## Part 2: Realm Authentication

Now let's add realm-based authentication where only specific realms can call certain functions.

### Step 1: Add ResetOwnership Method

Add this method to your ` + "`callee.gno`" + ` file:

` + "```go" + `
func ResetOwnership(cur realm) {
	// Only allow calls from the specific caller realm
	expectedPkgPath := "gno.land/r/auth/caller"

	caller := std.PreviousRealm()
	if caller.PkgPath() != expectedPkgPath {
		panic("unauthorized realm: only " + expectedPkgPath + " can reset ownership")
	}

	owner = ""
}
` + "```" + `

### Step 2: Modify Claim Method

Update the ` + "`Claim`" + ` method to panic if called by a realm:
` + "```diff" + `
func Claim(cur realm) {
	if owner != "" {
		panic("owner already set")
	}

	caller := std.PreviousRealm()
+	if !caller.IsUser() {
+		panic("only users can claim ownership")
+	}
+
	owner = caller.Address()
}
` + "```" + `

### Step 3: Create the Caller Realm

Create ` + "`gno.land/r/auth/caller/caller.gno`" + `:

` + "```go" + `
package caller

import (
	"std"

	"gno.land/r/auth/callee"
)

func CallClaim(cur realm) {
	// This will panic because realms cannot claim ownership
	callee.Claim(cross)
}

func CallTransferOwnership(cur realm, newOwner std.Address) {
	// This will panic because realms cannot be the owner
	// and therefore cannot transfer ownership
	callee.TransferOwnership(cross, newOwner)
}

func CallResetOwnership(cur realm) {
	// This will succeed because this realm is authorized to reset
	callee.ResetOwnership(cross)
}

func Render(_ string) string {
	out := "# Caller Realm\n"
	out += "I can only reset but not be the owner."
	return out
}
` + "```" + `

### Step 4: Create gnomod.toml for Caller

Create ` + "`gno.land/r/auth/caller/gnomod.toml`" + `:

` + "```toml" + `
module = "gno.land/r/auth/caller"
gno = "0.9"
` + "```" + `

### Step 5: Test Realm Authentication

First, ensure the callee realm has an owner, then test realm interactions:

` + "```bash" + `
# Try to call ResetOwnership directly as a user (should fail)
gnokey maketx call \
    -pkgpath "gno.land/r/auth/callee" \
    -func "ResetOwnership" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser

# Try to call ResetOwnership through the caller realm (should succeed)
gnokey maketx call \
    -pkgpath "gno.land/r/auth/caller" \
    -func "CallResetOwnership" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser

# Try to call Claim through the caller realm (should fail)
gnokey maketx call \
    -pkgpath "gno.land/r/auth/caller" \
    -func "CallClaim" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser

# Try to call Claim directly as a user (should succeed)
gnokey maketx call \
    -pkgpath "gno.land/r/auth/callee" \
    -func "Claim" \
    -gas-fee "1000000ugnot" \
    -gas-wanted "3000000" \
    -broadcast \
    testuser
` + "```" + `

Visit [/r/auth/callee](/r/auth/callee) to confirm that ownership updates correctly.
## Final Testing

### Manual Testing Checklist

1. **User Authentication**:
   - [ ] Users can claim ownership when no owner exists
   - [ ] Claiming fails when owner already exists
   - [ ] Only the current owner can transfer ownership
   - [ ] Ownership transfers correctly to new valid addresses

2. **Realm Authentication**:
   - [ ] Realms cannot claim or transfer ownership (user-only functions)
   - [ ] Only the authorized caller realm can reset ownership
   - [ ] Unauthorized realms cannot reset ownership

### Automated Testing

Run the provided test suite to verify all functionality:

` + "```bash" + `
cd gno.land/r/auth/callee
gno test -v ./...
` + "```" + `

## Key Takeaways

By completing this exercise, you've learned:

- **User vs Realm Authentication**: How to distinguish between user calls (` + "`std.PreviousRealm().IsUser()`" + `) and realm calls
- **Caller Verification**: Using ` + "`std.PreviousRealm().Address()`" + ` to verify user identity and ` + "`std.PreviousRealm().PkgPath()`" + ` to verify realm identity
- **Authorization Patterns**: Implementing owner-only functions and realm-specific permissions
- **Security Through Panic**: Using ` + "`panic`" + ` to immediately halt execution and prevent unauthorized state changes
- **Cross-Realm Communication**: How realms can call each other while maintaining proper security boundaries

These patterns form the foundation of secure Gno realm development!

**Next Steps:** [Continue to Exercise 04](/r/workshop/ex04)
`
}
