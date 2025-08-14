package callee

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/uassert"
)

func TestClaim(t *testing.T) {
	// Reset state
	owner = ""

	// Test claiming ownership
	user1 := testutils.TestAddress("user1")
	testing.SetOriginCaller(user1)
	Claim(cross)

	if owner != user1 {
		t.Errorf("Expected owner to be %s, got %s", user1, owner)
	}
}

func TestClaimAlreadySet(t *testing.T) {
	// Set initial owner
	owner = testutils.TestAddress("user1")

	// Try to claim again - should panic
	user2 := testutils.TestAddress("user2")
	testing.SetOriginCaller(user2)

	uassert.AbortsWithMessage(t, "owner already set", func() {
		Claim(cross)
	})
}

func TestClaimFromRealm(t *testing.T) {
	// Reset state
	owner = ""

	// Test claiming from a realm (should fail)
	testing.SetRealm(std.NewCodeRealm("gno.land/r/some/realm"))

	uassert.AbortsWithMessage(t, "only users can claim ownership", func() {
		Claim(cross)
	})
}

func TestTransferOwnership(t *testing.T) {
	// Set initial owner
	initialOwner := testutils.TestAddress("user1")
	owner = initialOwner

	// Transfer ownership
	testing.SetOriginCaller(initialOwner)
	newOwner := testutils.TestAddress("user2")
	TransferOwnership(cross, newOwner)

	if owner != newOwner {
		t.Errorf("Expected owner to be %s, got %s", newOwner, owner)
	}
}

func TestTransferOwnershipNoOwner(t *testing.T) {
	// Reset state
	owner = ""

	user1 := testutils.TestAddress("user1")
	testing.SetOriginCaller(user1)

	uassert.AbortsWithMessage(t, "no owner set", func() {
		user2 := testutils.TestAddress("user2")
		TransferOwnership(cross, user2)
	})
}

func TestTransferOwnershipUnauthorized(t *testing.T) {
	// Set initial owner
	owner = testutils.TestAddress("user1")

	// Try to transfer from different user
	user2 := testutils.TestAddress("user2")
	testing.SetOriginCaller(user2)

	uassert.AbortsWithMessage(t, "only owner can transfer ownership", func() {
		user3 := testutils.TestAddress("user3")
		TransferOwnership(cross, user3)
	})
}

func TestTransferOwnershipFromRealm(t *testing.T) {
	// Set initial owner
	owner = testutils.TestAddress("user1")

	// Try to transfer from a realm
	testing.SetRealm(std.NewCodeRealm("gno.land/r/some/realm"))

	uassert.AbortsWithMessage(t, "only owner can transfer ownership", func() {
		user2 := testutils.TestAddress("user2")
		TransferOwnership(cross, user2)
	})
}

func TestTransferOwnershipInvalidAddress(t *testing.T) {
	// Set initial owner
	initialOwner := testutils.TestAddress("user1")
	owner = initialOwner

	testing.SetOriginCaller(initialOwner)

	uassert.AbortsWithMessage(t, "invalid address", func() {
		TransferOwnership(cross, std.Address(""))
	})
}

func TestRender(t *testing.T) {
	// Test render with no owner
	owner = ""
	result := Render("")
	expected := "# Callee Realm\nNo owner set yet."
	if result != expected {
		t.Errorf("Expected %s, got %s", expected, result)
	}

	// Test render with owner
	user1 := testutils.TestAddress("user1")
	owner = user1
	result = Render("")
	expected = "# Callee Realm\nCurrent owner: " + string(user1)
	if result != expected {
		t.Errorf("Expected %s, got %s", expected, result)
	}
}

// TODO: When the package.Load will be integrated into the gno test
// command line tool, change this package name for callee_test then
// add tests for ResetOwnership.
