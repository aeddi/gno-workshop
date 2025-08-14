package hellocounter

import "strconv"

var counter int

func Render(_ string) string {
	return "Hello World! Counter: " + strconv.Itoa(counter)
}

func Increment(cur realm) {
	counter++
}

func Decrement(cur realm) {
	counter--
}

func Reset(cur realm) {
	counter = 0
}
