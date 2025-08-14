package hellocounter

import (
	"testing"

	"gno.land/p/demo/uassert"
)

func TestInitialState(t *testing.T) {
	// Reset state for testing
	counter = 0
	name = "World"

	expected := "Hello, World! Counter: 0"
	uassert.Equal(t, expected, Render(""))
}

func TestIncrement(cur realm, t *testing.T) {
	// Reset state
	counter = 0
	name = "World"

	// Test increment
	Increment(cur)
	uassert.Equal(t, 1, counter)

	// Test render after increment
	expected := "Hello, World! Counter: 1"
	uassert.Equal(t, expected, Render(""))
}

func TestDecrement(cur realm, t *testing.T) {
	// Set initial state
	counter = 5
	name = "World"

	// Test decrement
	Decrement(cur)
	uassert.Equal(t, 4, counter)

	// Test render after decrement
	expected := "Hello, World! Counter: 4"
	uassert.Equal(t, expected, Render(""))
}

func TestReset(cur realm, t *testing.T) {
	// Set non-zero state
	counter = 42
	name = "World"

	// Test reset
	Reset(cur)
	uassert.Equal(t, 0, counter)

	// Test render after reset
	expected := "Hello, World! Counter: 0"
	uassert.Equal(t, expected, Render(""))
}

func TestSetName(cur realm, t *testing.T) {
	// Reset state
	counter = 0
	name = "World"

	// Test set name
	SetName(cur, "Alice")
	uassert.Equal(t, "Alice", name)

	// Test render with new name
	expected := "Hello, Alice! Counter: 0"
	uassert.Equal(t, expected, Render(""))
}

func TestCompleteWorkflow(cur realm, t *testing.T) {
	// Reset state
	counter = 0
	name = "World"

	// Test complete workflow
	SetName(cur, "Bob")
	Increment(cur)
	Increment(cur)
	Increment(cur)

	expected := "Hello, Bob! Counter: 3"
	uassert.Equal(t, expected, Render(""))

	// Test decrement
	Decrement(cur)
	expected = "Hello, Bob! Counter: 2"
	uassert.Equal(t, expected, Render(""))

	// Test reset
	Reset(cur)
	expected = "Hello, Bob! Counter: 0"
	uassert.Equal(t, expected, Render(""))
}
