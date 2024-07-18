const flowchart = {
  start: {
    question: "Is it an interesting area to get a status on:\n1. # defects + their severity\n2. # failed runs\n3. % automation coverage\nDo we want to improve the quality in this area?",
    yes: 'shouldBeAppModule',
    no: 'newFunctionality'
  },
  shouldBeAppModule: {
    question: "Should be an App module",
    final: true
  },
  newFunctionality: {
    question: "Is it interesting to know which new functionality was developed in this area in the last release?",
    yes: 'containerAppModule',
    no: 'assignmentsResponsibility'
  },
  containerAppModule: {
    question: "Is it maybe a Container app module?",
    yes: 'limitedInfra',
    no: 'noAppModule'
  },
  assignmentsResponsibility: {
    question: "Is it for assignments and responsibility definition?",
    yes: 'thirdLevelAppModule',
    no: 'noAppModule'
  },
  thirdLevelAppModule: {
    question: "Probably a 3rd level app module",
    final: true
  },
  noAppModule: {
    question: "No App module",
    final: true
  },
  limitedInfra: {
    question: "Those needs to be limited (Infra/Common etc). Take extra care while creating such. If it is not a must – Don’t",
    final: true
  }
};

let currentStep = 'start';

function displayStep(step) {
  const container = document.querySelector('.container');

  const wrapperDiv = document.createElement('div');
  wrapperDiv.className = 'wrapper';

  const questionDiv = document.createElement('div');
  questionDiv.className = 'question';
  questionDiv.innerText = flowchart[step].question;
  wrapperDiv.appendChild(questionDiv);

  const optionsDiv = document.createElement('div');
  optionsDiv.className = 'options';
  wrapperDiv.appendChild(optionsDiv);

  container.appendChild(wrapperDiv);

  if (flowchart[step].final) {
    const resetButton = document.createElement('button');
    resetButton.innerText = 'Reset';
    resetButton.onclick = () => {
      container.innerHTML = '';
      currentStep = 'start';
      displayStep(currentStep);
    };
    optionsDiv.appendChild(resetButton);
    return;
  }

  const yesButton = document.createElement('button');
  yesButton.innerText = 'YES';
  yesButton.onclick = () => {
    wrapperDiv.classList.add('faded');
    yesButton.disabled = true;
    noButton.disabled = true;
    currentStep = flowchart[step].yes;
    displayStep(currentStep);
  };

  const noButton = document.createElement('button');
  noButton.innerText = 'NO';
  noButton.onclick = () => {
    wrapperDiv.classList.add('faded');
    yesButton.disabled = true;
    noButton.disabled = true;
    currentStep = flowchart[step].no;
    displayStep(currentStep);
  };

  optionsDiv.appendChild(yesButton);
  optionsDiv.appendChild(noButton);
}

document.addEventListener('DOMContentLoaded', () => {
  displayStep(currentStep);
});
