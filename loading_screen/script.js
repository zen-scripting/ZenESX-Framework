class ZenLoadingScreen {
    constructor() {
        this.currentProgress = 0;
        this.currentStatus = 0;
        this.maxStatus = 6;
        this.loadingSteps = [
            "Framework wird initialisiert...",
            "Verbindung zum Server...", 
            "Erweiterte Scripts werden geladen...",
            "Spielerdaten werden geladen...",
            "Jobs & Fraktionen werden synchronisiert...",
            "Bereit zum Spielen!"
        ];
        
        this.tips = [
            "Verwende /help um alle verfügbaren Befehle anzuzeigen!",
            "Drücke F1 für das Hauptmenü und F2 für das Inventar!",
            "Jobs findest du an den blauen Markierungen auf der Karte!",
            "Mit /me kannst du Roleplay-Aktionen ausführen!",
            "Respektiere andere Spieler für das beste RP-Erlebnis!",
            "Fahrzeuge kannst du in den Autohäusern kaufen!",
            "Die Polizei hilft dir gerne bei Fragen und Problemen!",
            "Vergiss nicht, regelmäßig zu essen und zu trinken!"
        ];
        
        this.currentTip = 0;
        this.audioInitialized = false;
        
        this.init();
    }
    
    init() {
        this.setupAudioControls();
        this.startLoading();
        this.rotateTips();
        this.setupEventListeners();
    }
    
    setupAudioControls() {
        const audio = document.getElementById('backgroundMusic');
        const muteButton = document.getElementById('muteButton');
        const volumeSlider = document.getElementById('volumeSlider');
        
        // Initial volume setup
        audio.volume = 0.5;
        
        // Auto-play with user interaction
        document.addEventListener('click', () => {
            if (!this.audioInitialized) {
                audio.play().catch(e => console.log('Audio autoplay prevented:', e));
                this.audioInitialized = true;
            }
        }, { once: true });
        
        // Mute/Unmute functionality
        muteButton.addEventListener('click', () => {
            if (audio.muted) {
                audio.muted = false;
                muteButton.textContent = '🔊';
                muteButton.style.background = 'linear-gradient(45deg, #00ff7f, #00bfff)';
            } else {
                audio.muted = true;
                muteButton.textContent = '🔇';
                muteButton.style.background = 'linear-gradient(45deg, #ff4757, #ff6b7a)';
            }
        });
        
        // Volume control
        volumeSlider.addEventListener('input', (e) => {
            audio.volume = e.target.value / 100;
        });
        
        // Try to play immediately
        setTimeout(() => {
            audio.play().catch(e => {
                console.log('Audio autoplay prevented, waiting for user interaction');
            });
        }, 1000);
    }
    
    startLoading() {
        const progressBar = document.getElementById('loadingProgress');
        const percentageDisplay = document.getElementById('loadingPercentage');
        
        const loadingInterval = setInterval(() => {
            if (this.currentProgress >= 100) {
                clearInterval(loadingInterval);
                this.completeLoading();
                return;
            }
            
            // Simulate realistic loading with variable speeds
            let increment = Math.random() * 3 + 1;
            
            // Slower progress at certain points for realism
            if (this.currentProgress > 20 && this.currentProgress < 30) increment *= 0.5;
            if (this.currentProgress > 60 && this.currentProgress < 75) increment *= 0.3;
            if (this.currentProgress > 85) increment *= 0.2;
            
            this.currentProgress = Math.min(this.currentProgress + increment, 100);
            
            progressBar.style.width = this.currentProgress + '%';
            percentageDisplay.textContent = Math.floor(this.currentProgress) + '%';
            
            // Update status based on progress
            this.updateStatus();
            
        }, 150 + Math.random() * 100);
    }
    
    updateStatus() {
        const progressThresholds = [0, 15, 35, 55, 75, 95];
        const newStatus = progressThresholds.findIndex((threshold, index) => {
            return this.currentProgress >= threshold && 
                   (index === progressThresholds.length - 1 || this.currentProgress < progressThresholds[index + 1]);
        });
        
        if (newStatus !== this.currentStatus && newStatus >= 0) {
            // Remove active class from previous status
            if (this.currentStatus >= 0) {
                const prevStatus = document.getElementById(`status${this.currentStatus + 1}`);
                if (prevStatus) prevStatus.classList.remove('active');
            }
            
            this.currentStatus = newStatus;
            
            // Add active class to current status
            const currentStatusElement = document.getElementById(`status${this.currentStatus + 1}`);
            if (currentStatusElement) {
                currentStatusElement.classList.add('active');
                
                // Update status text
                const statusText = currentStatusElement.querySelector('.status-text');
                if (statusText && this.loadingSteps[this.currentStatus]) {
                    statusText.textContent = this.loadingSteps[this.currentStatus];
                }
                
                // Update icon for completed steps
                const statusIcon = currentStatusElement.querySelector('.status-icon');
                if (statusIcon && this.currentStatus < this.loadingSteps.length - 1) {
                    setTimeout(() => {
                        statusIcon.textContent = '✅';
                        currentStatusElement.classList.remove('active');
                    }, 1000);
                }
            }
        }
    }
    
    rotateTips() {
        const tipElement = document.getElementById('loadingTip');
        
        setInterval(() => {
            this.currentTip = (this.currentTip + 1) % this.tips.length;
            
            // Fade out
            tipElement.style.opacity = '0';
            
            setTimeout(() => {
                tipElement.textContent = this.tips[this.currentTip];
                // Fade in
                tipElement.style.opacity = '1';
            }, 300);
            
        }, 4000);
    }
    
    setupEventListeners() {
        // Listen for FiveM events
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            switch(data.type) {
                case 'loadingProgress':
                    this.setProgress(data.progress);
                    break;
                case 'loadingStatus':
                    this.setStatus(data.status);
                    break;
                case 'showLoading':
                    document.body.style.display = 'block';
                    break;
                case 'hideLoading':
                    this.completeLoading();
                    break;
            }
        });
    }
    
    setProgress(progress) {
        this.currentProgress = Math.max(0, Math.min(100, progress));
        const progressBar = document.getElementById('loadingProgress');
        const percentageDisplay = document.getElementById('loadingPercentage');
        
        progressBar.style.width = this.currentProgress + '%';
        percentageDisplay.textContent = Math.floor(this.currentProgress) + '%';
        
        this.updateStatus();
    }
    
    setStatus(statusText) {
        const currentStatusElement = document.getElementById(`status${this.currentStatus + 1}`);
        if (currentStatusElement) {
            const statusTextElement = currentStatusElement.querySelector('.status-text');
            if (statusTextElement) {
                statusTextElement.textContent = statusText;
            }
        }
    }
    
    completeLoading() {
        // Mark final status as complete
        const finalStatus = document.getElementById(`status${this.maxStatus}`);
        if (finalStatus) {
            finalStatus.classList.add('active');
            const finalIcon = finalStatus.querySelector('.status-icon');
            if (finalIcon) finalIcon.textContent = '✅';
        }
        
        // Fade out after a delay
        setTimeout(() => {
            document.body.style.opacity = '0';
            document.body.style.transition = 'opacity 1s ease-out';
            
            setTimeout(() => {
                // Notify FiveM that loading is complete
                if (window.invokeNative) {
                    window.invokeNative('shutdown');
                } else {
                    // For testing purposes
                    console.log('Loading complete - would shutdown loading screen');
                }
            }, 1000);
        }, 2000);
    }
}

// Initialize loading screen when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new ZenLoadingScreen();
});

// Prevent right-click context menu
document.addEventListener('contextmenu', (e) => {
    e.preventDefault();
});

// Prevent F12 and other developer tools
document.addEventListener('keydown', (e) => {
    if (e.key === 'F12' || 
        (e.ctrlKey && e.shiftKey && e.key === 'I') ||
        (e.ctrlKey && e.shiftKey && e.key === 'C') ||
        (e.ctrlKey && e.key === 'u')) {
        e.preventDefault();
    }
});