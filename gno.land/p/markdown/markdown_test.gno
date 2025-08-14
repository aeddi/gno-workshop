package markdown

import (
	"testing"

	"gno.land/p/demo/uassert"
)

func TestH1(t *testing.T) {
	expected := "# Hello World\n\n"
	uassert.Equal(t, H1("Hello World"), expected)
}

func TestH2(t *testing.T) {
	expected := "## Hello World\n\n"
	uassert.Equal(t, H2("Hello World"), expected)
}

func TestH3(t *testing.T) {
	expected := "### Hello World\n\n"
	uassert.Equal(t, H3("Hello World"), expected)
}

func TestParagraph(t *testing.T) {
	expected := "This is a paragraph.\n\n"
	uassert.Equal(t, Paragraph("This is a paragraph."), expected)
}

func TestOrderedList(t *testing.T) {
	expected := "1. First item\n2. Second item\n3. Third item\n\n"
	uassert.Equal(t, OrderedList([]string{"First item", "Second item", "Third item"}), expected)
}

func TestBulletList(t *testing.T) {
	expected := "- First item\n- Second item\n- Third item\n\n"
	uassert.Equal(t, BulletList([]string{"First item", "Second item", "Third item"}), expected)
}
