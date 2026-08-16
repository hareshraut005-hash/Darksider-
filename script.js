// ================================================================
//  CORE LOGIC - TTS + QUIZ ENGINE (Language Aware)
// ================================================================

// ----- References -----
const topicTitle = document.getElementById('topicTitle');
const topicContent = document.getElementById('topicContent');
const quizContainer = document.getElementById('quizContainer');
const progressBadge = document.getElementById('progressBadge');
const progressFill = document.getElementById('progressFill');
const voiceBtn = document.getElementById('voiceBtn');
const voiceLabel = document.getElementById('voiceLabel');
const voiceSelect = document.getElementById('voiceSelect');
const speedRange = document.getElementById('speedRange');
const speedDisplay = document.getElementById('speedDisplay');
const langSelect = document.getElementById('langSelect');
const quizTitle = document.getElementById('quizTitle');

let synth = window.speechSynthesis;
let utterance = null;
let isSpeaking = false;

// ----- State -----
let currentLang = 'en';   // 'en' or 'hi'
let currentQuestion = 0;
let score = 0;
let answered = false;

// ----- Speech Setup -----
function populateVoices() {
    const voices = synth.getVoices();
    voiceSelect.innerHTML = '';
    voices.forEach((voice, i) => {
        const opt = document.createElement('option');
        opt.value = i;
        opt.textContent = `${voice.name} (${voice.lang})`;
        voiceSelect.appendChild(opt);
    });
    // Prefer voice matching current language
    let selectedIndex = 0;
    const prefLang = currentLang === 'hi' ? 'hi' : 'en';
    for (let i = 0; i < voices.length; i++) {
        if (voices[i].lang.startsWith(prefLang)) {
            selectedIndex = i;
            break;
        }
    }
    voiceSelect.value = selectedIndex;
}
populateVoices();
synth.onvoiceschanged = populateVoices;

speedRange.addEventListener('input', () => {
    speedDisplay.textContent = parseFloat(speedRange.value).toFixed(1) + 'x';
});

function getCurrentVoice() {
    const voices = synth.getVoices();
    const idx = parseInt(voiceSelect.value) || 0;
    return voices[idx] || null;
}

function getCurrentRate() {
    return parseFloat(speedRange.value) || 1;
}

function speakText(text) {
    if (isSpeaking) {
        synth.cancel();
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = getUI('listen');
        return;
    }
    synth.cancel();
    utterance = new SpeechSynthesisUtterance(text);
    utterance.voice = getCurrentVoice();
    utterance.rate = getCurrentRate();
    utterance.pitch = 1;
    utterance.lang = currentLang === 'hi' ? 'hi-IN' : 'en-US';

    utterance.onstart = () => {
        isSpeaking = true;
        voiceBtn.classList.add('playing');
        voiceLabel.textContent = getUI('stop');
    };
    utterance.onend = () => {
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = getUI('listen');
    };
    utterance.onerror = () => {
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = getUI('listen');
    };
    synth.speak(utterance);
}

voiceBtn.addEventListener('click', () => {
    const data = APP_DATA[currentLang];
    const fullText = `${data.topic.title}. ${data.topic.content}`;
    speakText(fullText);
});

// Stop voice on settings change
voiceSelect.addEventListener('change', () => { if (isSpeaking) { stopSpeech(); } });
speedRange.addEventListener('change', () => { if (isSpeaking) { stopSpeech(); } });

function stopSpeech() {
    if (isSpeaking) {
        synth.cancel();
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = getUI('listen');
    }
}

// ----- UI Translation Helper -----
function getUI(key) {
    const ui = {
        en: { listen: 'Listen', stop: 'Stop', next: 'Next →', restart: 'Play Again',
            score: 'Your Score', done: '🎯 Done!', correct: '✅ Correct! Well done.',
            wrong: '❌ Wrong. Correct answer: ',
            perfect: '🏆 Perfect! You are a legend!',
            great: '🌟 Great job! Keep learning!',
            good: '📖 Good effort! Review once more.',
            try: '💪 Don\'t give up! Try again.',
            quizTitle: '🧠 Quick Quiz'
        },
        hi: { listen: 'सुनें', stop: 'रोकें', next: 'अगला →', restart: '🔄 फिर से खेलें',
            score: 'आपका स्कोर', done: '🎯 खत्म!', correct: '✅ सही! बहुत अच्छे!',
            wrong: '❌ गलत। सही उत्तर: ',
            perfect: '🏆 शानदार! आप तो एक्सपर्ट हो!',
            great: '🌟 बहुत बढ़िया! सीखते रहो!',
            good: '📖 अच्छी कोशिश! एक बार और पढ़ लो.',
            try: '💪 हिम्मत मत हारो! दोबारा ट्राई करो.',
            quizTitle: '🧠 क्विक क्विज़'
        }
    };
    return ui[currentLang]?.[key] || key;
}

// ----- Language Change -----
function setLanguage(lang) {
    currentLang = lang;
    const data = APP_DATA[lang];
    // Update topic
    topicTitle.textContent = data.topic.title;
    topicContent.textContent = data.topic.content;
    quizTitle.textContent = getUI('quizTitle');
    // Reset quiz
    currentQuestion = 0;
    score = 0;
    answered = false;
    renderQuiz();
    // Update voice select to prefer current language
    populateVoices();
    // Update button text
    voiceLabel.textContent = getUI('listen');
    stopSpeech();
}

langSelect.addEventListener('change', (e) => {
    setLanguage(e.target.value);
});

// ----- Quiz Engine -----
const letters = ['A', 'B', 'C', 'D'];

function renderQuiz() {
    const data = APP_DATA[currentLang];
    const quizzes = data.quizzes;
    const ui = getUI;

    if (currentQuestion >= quizzes.length) {
        let msg = '';
        const pct = (score / quizzes.length) * 100;
        if (pct === 100) msg = ui('perfect');
        else if (pct >= 66) msg = ui('great');
        else if (pct >= 33) msg = ui('good');
        else msg = ui('try');

        quizContainer.innerHTML = `
            <div class="score-card">
                <div class="big-score">${score} / ${quizzes.length}</div>
                <p>${ui('score')}</p>
                <div class="msg">${msg}</div>
                <button class="btn-restart" onclick="restartQuiz()">${ui('restart')}</button>
            </div>
        `;
        progressBadge.textContent = ui('done');
        progressFill.style.width = '100%';
        return;
    }

    const q = quizzes[currentQuestion];
    const total = quizzes.length;
    progressBadge.textContent = `${currentQuestion+1} / ${total}`;
    progressFill.style.width = `${((currentQuestion) / total) * 100}%`;

    let html = `<div class="question-text">${currentQuestion+1}. ${q.question}</div>`;
    html += `<div class="options" id="optionsContainer">`;
    q.options.forEach((opt, idx) => {
        html += `
            <button data-index="${idx}">
                <span class="opt-label">${letters[idx]}</span>
                ${opt}
            </button>
        `;
    });
    html += `</div>`;
    html += `<div class="feedback" id="feedback"></div>`;
    html += `<div class="quiz-actions">
                <button class="btn-next" id="nextBtn" disabled>${ui('next')}</button>
            </div>`;
    quizContainer.innerHTML = html;

    const optionBtns = document.querySelectorAll('.options button');
    const feedback = document.getElementById('feedback');
    const nextBtn = document.getElementById('nextBtn');

    optionBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            if (answered) return;
            const selected = parseInt(this.dataset.index);
            const isCorrect = (selected === q.correct);

            optionBtns.forEach(b => b.disabled = true);
            optionBtns.forEach((b, i) => {
                if (i === q.correct) b.classList.add('correct');
                if (i === selected && !isCorrect) b.classList.add('wrong');
            });
            if (isCorrect) score++;

            feedback.textContent = isCorrect ? ui('correct') :
                `${ui('wrong')} ${q.options[q.correct]}`;
            feedback.className = `feedback show ${isCorrect ? 'correct' : 'wrong'}`;
            answered = true;
            nextBtn.disabled = false;
        });
    });

    nextBtn.addEventListener('click', () => {
        stopSpeech();
        currentQuestion++;
        answered = false;
        renderQuiz();
    });
    answered = false;
}

function restartQuiz() {
    stopSpeech();
    currentQuestion = 0;
    score = 0;
    answered = false;
    renderQuiz();
}

// Expose restart to global for inline onclick
window.restartQuiz = restartQuiz;

// ----- Initial Load -----
// Set default language from dropdown
setLanguage(langSelect.value);