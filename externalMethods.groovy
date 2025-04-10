// externalMethods.groovy

def printWelcomeMessage() {
    echo "Welcome to Jenkins Pipeline!"
}

def calculateSum(a, b) {
    return a + b
}

def printSum(a, b) {
    def sum = calculateSum(a, b)
    echo "The sum of ${a} and ${b} is: ${sum}"
}

return [
    printWelcomeMessage: printWelcomeMessage,
    printSum: printSum
]
