package router

import (
	"testing"

	"gno.land/p/demo/uassert"
)

func TestRenderHomepage(t *testing.T) {
	result := Render("")

	uassert.NotEmpty(t, result)

	// Should contain welcome message
	uassert.True(t, contains(t, result, "Welcome to Router Demo"))

	// Should contain navigation links
	uassert.True(t, contains(t, result, "Available Pages"))
}

func TestRenderUserProfile(t *testing.T) {
	result := Render("user/alice")

	// Should contain Alice's name
	uassert.True(t, contains(t, result, "alice"), "Should render Alice's profile")

	// Should contain profile content
	uassert.True(t, contains(t, result, "User Profile"), "Should contain profile header")
}

func TestRenderPost(t *testing.T) {
	result := Render("post/123")

	// Should contain the post ID
	uassert.True(t, contains(t, result, "123"), "Should render post with ID 123")

	// Should contain post header
	uassert.True(t, contains(t, result, "Post #123"), "Should contain post header")
}

func TestRenderAbout(t *testing.T) {
	result := Render("about")

	// Should contain about content
	uassert.True(t, contains(t, result, "About This Router"), "Should render about page")

	// Should contain feature descriptions
	uassert.True(t, contains(t, result, "Static routes"), "Should describe static routes")
}

func TestRenderSearch(t *testing.T) {
	result := Render("search?q=gno")

	// Should contain search results
	uassert.True(t, contains(t, result, "Search Results"), "Should render search results page")

	// Should contain the search query
	uassert.True(t, contains(t, result, "gno"), "Should show the search query")
}

func TestRenderSearchEmpty(t *testing.T) {
	result := Render("search")

	// Should contain search page
	uassert.True(t, contains(t, result, "Search Results"), "Should render search page")

	// Should ask for query parameter
	uassert.True(t, contains(t, result, "Please provide a search query"), "Should ask for search query when empty")
}

// Helper function to check if a string contains a substring
func contains(t *testing.T, s, substr string) bool {
	t.Helper()
	return len(s) >= len(substr) && findInString(t, s, substr)
}

func findInString(t *testing.T, s, substr string) bool {
	t.Helper()
	if len(substr) > len(s) {
		return false
	}
	for i := 0; i <= len(s)-len(substr); i++ {
		if s[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}
