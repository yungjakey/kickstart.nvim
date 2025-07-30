package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, World!")
	a := []int{1, 2, 3, 4, 5}
	for i, v := range a {
		fmt.Printf("Index: %d, Value: %d\n", i, v)
	}

}
