package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"time"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Fprint(w, "world")
}

func main() {
	failPercentageEnv := os.Getenv("FAIL_PERCENTAGE")
	if failPercentageEnv == "" {
		fmt.Println("Must define environment variable 'FAIL_PERCENTAGE'")
		os.Exit(1)
	}

	failPercentage, err := strconv.Atoi(failPercentageEnv)
	if err != nil || failPercentage > 100 || failPercentage < 0 {
		fmt.Println("%s is not a valid percentage", failPercentageEnv)
		os.Exit(1)
	}

	s1 := rand.NewSource(time.Now().UnixNano())
	r1 := rand.New(s1)
	randNum := r1.Intn(100)

	listenPort := ":8080"
	if randNum <= failPercentage {
		listenPort = ":1234"
	}

	fmt.Sprintln("Listen port %s", listenPort)

	http.HandleFunc("/hello", hello)

	http.ListenAndServe(listenPort, nil)
}
