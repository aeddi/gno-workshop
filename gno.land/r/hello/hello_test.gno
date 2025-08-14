package hello

import (
	"testing"

	"gno.land/p/demo/uassert"
)

func TestHello(t *testing.T) {
	const expected = "# Hello, Gno World!\nWelcome to my first realm!"
	uassert.Equal(t, expected, Render(""))
}
