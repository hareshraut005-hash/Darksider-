// ============================================================
//  CORE LOGIC (TTS + QUIZ) — HINGLISH VOICE & MESSAGES
// ============================================================

let synth = window.speechSynthesis;
let utterance = null;
let isSpeaking = false;

const voiceBtn = document.getElementById('voiceBtn');
const voiceLabel = document.getElementById('voiceLabel');
const voiceSelect = document.getElementById('voiceSelect');
const speedRange = document.getElementById('speedRange');
const speedDisplay = document.getElementById('speedDisplay');

// ---------- VOICE SETUP (Hindi preferred) ----------
function populateVoices() {
    const voices = synth.getVoices();
    voiceSelect.innerHTML = '';
    voices.forEach((voice, i) => {
        const opt = document.createElement('option');
        opt.value = i;
        opt.textContent = `${voice.name} (${voice.lang})`;
        voiceSelect.appendChild(opt);
    });

    let selectedIndex = 0;
    for (let i = 0; i < voices.length; i++) {
        if (voices[i].lang.startsWith('hi')) {
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

// ---------- SPEAK FUNCTION ----------
function speakText(text) {
    if (isSpeaking) {
        synth.cancel();
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = 'सुनें';
        return;
    }
    synth.cancel();
    utterance = new SpeechSynthesisUtterance(text);
    utterance.voice = getCurrentVoice();
    utterance.rate = getCurrentRate();
    utterance.pitch = 1;
    utterance.lang = 'hi-IN';

    utterance.onstart = () => {
        isSpeaking = true;
        voiceBtn.classList.add('playing');
        voiceLabel.textContent = 'रोकें';
    };
    utterance.onend = () => {
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = 'सुनें';
    };
    utterance.onerror = () => {
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = 'सुनें';
    };
    synth.speak(utterance);
}

voiceBtn.addEventListener('click', () => {
    const fullText = `${APP_DATA.topic.title}. ${APP_DATA.topic.content}`;
    speakText(fullText);
});

// Stop voice on settings change
voiceSelect.addEventListener('change', () => { if (isSpeaking) { synth.cancel();
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = 'सुनें'; } });
speedRange.addEventListener('change', () => { if (isSpeaking) { synth.cancel();
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = 'सुनें'; } });

// ---------- QUIZ ENGINE ----------
let currentQuestion = 0;
let score = 0;
let answered = false;

const quizContainer = document.getElementById('quizContainer');
const progressBadge = document.getElementById('progressBadge');
const progressFill = document.getElementById('progressFill');
const letters = ['क', 'ख', 'ग', 'घ'];

function renderQuiz() {
    if (currentQuestion >= APP_DATA.quizzes.length) {
        let msg = '';
        const pct = (score / APP_DATA.quizzes.length) * 100;
        if (pct === 100) msg = '🏆 शानदार! आप तो एक्सपर्ट हो!';
        else if (pct >= 66) msg = '🌟 बहुत बढ़िया! सीखते रहो!';
        else if (pct >= 33) msg = '📖 अच्छी कोशिश! एक बार और पढ़ लो.';
        else msg = '💪 हिम्मत मत हारो! दोबारा ट्राई करो.';

        quizContainer.innerHTML = `
            <div class="score-card">
                <div class="big-score">${score} / ${APP_DATA.quizzes.length}</div>
                <p>आपका स्कोर</p>
                <div class="msg">${msg}</div>
                <button class="btn-restart" onclick="restartQuiz()">🔄 फिर से खेलें</button>
            </div>
        `;
        progressBadge.textContent = '🎯 खत्म!';
        progressFill.style.width = '100%';
        return;
    }

    const q = APP_DATA.quizzes[currentQuestion];
    const total = APP_DATA.quizzes.length;
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
                <button class="btn-next" id="nextBtn" disabled>अगला →</button>
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

            feedback.textContent = isCorrect ? '✅ सही! बहुत अच्छे!' :
                `❌ गलत। सही उत्तर: ${q.options[q.correct]}`;
            feedback.className = `feedback show ${isCorrect ? 'correct' : 'wrong'}`;
            answered = true;
            nextBtn.disabled = false;
        });
    });

    nextBtn.addEventListener('click', () => {
        if (isSpeaking) { synth.cancel();
            isSpeaking = false;
            voiceBtn.classList.remove('playing');
            voiceLabel.textContent = 'सुनें'; }
        currentQuestion++;
        answered = false;
        renderQuiz();
    });
    answered = false;
}

function restartQuiz() {
    if (isSpeaking) { synth.cancel();
        isSpeaking = false;
        voiceBtn.classList.remove('playing');
        voiceLabel.textContent = 'सुनें'; }
    currentQuestion = 0;
    score = 0;
    answered = false;
    renderQuiz();
}

// ---------- INIT ----------
document.getElementById('topicTitle').textContent = APP_DATA.topic.title;
document.getElementById('topicContent').textContent = APP_DATA.topic.content;
renderQuiz();
