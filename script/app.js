const inquirer = require('inquirer')
const fs = require('fs')

var express = require('express');
var app = express();

const textQuestion = {
  type: 'input',
  name: 'text',
  message: 'Please enter the text:'
}

const patternQuestion = {
  type: 'input',
  name: 'pattern',
  message: 'Please enter the pattern:'
}

function checkPattern(text, pattern, batchSize) {
  const regexp = new RegExp(pattern, 'gi')
  const allWords = text.split(' ')
  const batches = []
  let result = 0

  while (allWords.length) {
    batches.push(allWords.splice(0, batchSize))
  }

  batches.map(batch => result += batch.join(' ').match(regexp)?.length || 0)

  return result
}

function getOccurrences(text, pattern) {
  if (!Boolean(pattern)) {
    return console.log(`0 occurrences of pattern found in the text.`)
  }

  const occurrences = checkPattern(text, pattern, 4)

  console.log(`${occurrences} occurrences of pattern found in the text.`)

  server.close(() => {
    console.log('server closed')
    process.exit(0)

    main()
  })
}

function main() {
  try {
    const data = fs.readFileSync('text.txt', 'utf8')

    console.info('You have already provided your text in "text.txt"')

    inquirer.prompt([patternQuestion]).then(answers => getOccurrences(data.toString(), answers['pattern']))

  } catch (_) {
    console.warn('There is not any text.txt file so you have to enter your text:')

    inquirer.prompt([textQuestion, patternQuestion]).then(answers =>  getOccurrences(answers['text'], answers['pattern']))
  }
}

var server = app.listen(8081, function () {
  main()
});

