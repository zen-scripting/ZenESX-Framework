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
            "Drücke F2 für ox_inventory und F1 für das Hauptmenü!",
            "📱 Drücke F1 für dein Smartphone mit allen Apps!",
            "Jobs findest du an den blauen Markierungen auf der Karte!",
            "Mit /me kannst du Roleplay-Aktionen ausführen!",
            "Respektiere andere Spieler für das beste RP-Erlebnis!",
            "Fahrzeuge kannst du in den Autohäusern kaufen!",
            "Die Polizei hilft dir gerne bei Fragen und Problemen!",
            "Vergiss nicht, regelmäßig zu essen und zu trinken!",
            "📞 Nutze dein Handy für Anrufe, SMS und soziale Medien!",
            "💳 Überprüfe dein Bankkonto über die Banking-App!",
            "📸 Mache Fotos und teile sie in sozialen Medien!"
        ];
        
        this.currentTip = 0;
        this.audioInitialized = false;
        this.esxLoaded = false;
        this.isPlaying = true;
        
        this.init();
    }
    
    init() {
        this.setupAudioControls();
        this.startLoading();
        this.rotateTips();
        this.setupEventListeners();
        this.checkESXStatus();
        this.setupCursorVisibility(); // Mauszeiger-Sichtbarkeit sicherstellen
    }
    
    setupAudioControls() {
        const audio = document.getElementById('backgroundMusic');
        const muteButton = document.getElementById('muteButton');
        const playButton = document.getElementById('playButton');
        const volumeSlider = document.getElementById('volumeSlider');
        
        // Initial volume setup
        audio.volume = 0.7;
        audio.loop = true; // Musik läuft endlos
        
        // Auto-play with user interaction
        document.addEventListener('click', () => {
            if (!this.audioInitialized) {
                audio.play().catch(e => console.log('Audio autoplay prevented:', e));
                this.audioInitialized = true;
            }
        }, { once: true });
        
        // Play/Pause functionality
        playButton.addEventListener('click', () => {
            if (this.isPlaying) {
                audio.pause();
                playButton.textContent = '▶️';
                playButton.style.background = 'linear-gradient(45deg, #00ff7f, #00bfff)';
                this.isPlaying = false;
            } else {
                audio.play();
                playButton.textContent = '⏸️';
                playButton.style.background = 'linear-gradient(45deg, #ff6b35, #f7931e)';
                this.isPlaying = true;
            }
        });
        
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
            
            // Update volume label color based on level
            const volumeLabel = document.querySelector('.volume-label');
            if (volumeLabel) {
                if (e.target.value == 0) {
                    volumeLabel.style.color = '#ff4757';
                } else if (e.target.value < 30) {
                    volumeLabel.style.color = '#ffa502';
                } else if (e.target.value < 70) {
                    volumeLabel.style.color = '#00bfff';
                } else {
                    volumeLabel.style.color = '#00ff7f';
                }
            }
        });
        
        // Try to play immediately
        setTimeout(() => {
            audio.play().catch(e => {
                console.log('Audio autoplay prevented, waiting for user interaction');
            });
        }, 1000);
        
        // Additional attempts
        setTimeout(() => {
            if (!this.audioInitialized) {
                audio.play().catch(e => {
                    console.log('Second audio attempt failed');
                });
            }
        }, 3000);
        
        setTimeout(() => {
            if (!this.audioInitialized) {
                audio.play().catch(e => {
                    console.log('Third audio attempt failed');
                });
            }
        }, 5000);
        
        // Audio event listeners
        audio.addEventListener('play', () => {
            this.isPlaying = true;
            playButton.textContent = '⏸️';
            playButton.style.background = 'linear-gradient(45deg, #ff6b35, #f7931e)';
        });
        
        audio.addEventListener('pause', () => {
            this.isPlaying = false;
            playButton.textContent = '▶️';
            playButton.style.background = 'linear-gradient(45deg, #00ff7f, #00bfff)';
        });
        
        audio.addEventListener('ended', () => {
            // Restart if loop is disabled
            if (!audio.loop) {
                audio.play().catch(e => console.log('Failed to restart audio'));
            }
        });
    }
    
    checkESXStatus() {
        console.log('🔍 Starting ESX status check...');
        
        // Check ESX status every 50ms for better synchronization
        const esxCheck = setInterval(() => {
            try {
                // Check multiple ESX conditions - erweiterte Prüfung
                if (window.ESX && 
                    typeof window.ESX.IsPlayerLoaded === 'function' && 
                    window.ESX.IsPlayerLoaded() === true &&
                    window.ESX.PlayerData &&
                    window.ESX.PlayerData.identifier) {
                    
                    clearInterval(esxCheck);
                    this.esxLoaded = true;
                    console.log('✅ ESX fully loaded and player ready!');
                    
                    // Immediately sync loading bar to 100%
                    this.currentProgress = 100;
                    const progressBar = document.getElementById('loadingProgress');
                    const percentageDisplay = document.getElementById('loadingPercentage');
                    
                    if (progressBar) progressBar.style.width = '100%';
                    if (percentageDisplay) percentageDisplay.textContent = '100%';
                    
                    // Complete loading after short delay
                    setTimeout(() => {
                        this.completeLoading();
                    }, 2000);
                }
            } catch (error) {
                console.log('⚠️ ESX check error:', error);
            }
        }, 50); // Faster checking for better sync
        
        // Fallback timeout - länger warten auf ESX
        setTimeout(() => {
            clearInterval(esxCheck);
            if (!this.esxLoaded) {
                console.log('⏰ ESX timeout - warte noch länger...');
                
                // Zweiter Versuch - noch 30 Sekunden warten
                const secondCheck = setInterval(() => {
                    try {
                        if (window.ESX && 
                            typeof window.ESX.IsPlayerLoaded === 'function' && 
                            window.ESX.IsPlayerLoaded() === true &&
                            window.ESX.PlayerData &&
                            window.ESX.PlayerData.identifier) {
                            
                            clearInterval(secondCheck);
                            this.esxLoaded = true;
                            console.log('✅ ESX finally loaded after extended wait!');
                            
                            this.currentProgress = 100;
                            const progressBar = document.getElementById('loadingProgress');
                            const percentageDisplay = document.getElementById('loadingPercentage');
                            
                            if (progressBar) progressBar.style.width = '100%';
                            if (percentageDisplay) percentageDisplay.textContent = '100%';
                            
                            setTimeout(() => {
                                this.completeLoading();
                            }, 2000);
                        }
                    } catch (error) {
                        console.log('⚠️ Second ESX check error:', error);
                    }
                }, 100);
                
                // Finaler Timeout nach insgesamt 90 Sekunden
                setTimeout(() => {
                    clearInterval(secondCheck);
                    console.log('🚨 Final timeout - ESX still not ready, but continuing...');
                    this.esxLoaded = true;
                    this.currentProgress = 100;
                    
                    const progressBar = document.getElementById('loadingProgress');
                    const percentageDisplay = document.getElementById('loadingPercentage');
                    
                    if (progressBar) progressBar.style.width = '100%';
                    if (percentageDisplay) percentageDisplay.textContent = '100%';
                    
                    this.completeLoading();
                }, 60000); // Weitere 60 Sekunden
            }
        }, 30000); // Erste 30 Sekunden
    }
    
    startLoading() {
        const progressBar = document.getElementById('loadingProgress');
        const percentageDisplay = document.getElementById('loadingPercentage');
        
        // ESX-synchronisiertes Loading - PERFEKT SYNCHRON
        const loadingInterval = setInterval(() => {
            // Wenn ESX geladen ist, sofort auf 100% springen
            if (this.esxLoaded) {
                this.currentProgress = 100;
                progressBar.style.width = '100%';
                percentageDisplay.textContent = '100%';
                clearInterval(loadingInterval);
                return;
            }
            
            // Schnelleres Loading bis ESX bereit ist - 5-10 Sekunden schneller
            let increment = Math.random() * 0.8 + 0.4; // 0.4 to 1.2 (viel schneller)
            
            // Moderate Geschwindigkeit ab 80% - warten auf ESX
            if (this.currentProgress > 80) {
                increment = Math.random() * 0.15 + 0.05; // Moderate Geschwindigkeit
                this.currentProgress = Math.min(this.currentProgress + increment, 90); // Max 90% bis ESX bereit
            } else {
                this.currentProgress = Math.min(this.currentProgress + increment, 80);
            }
            
            progressBar.style.width = this.currentProgress + '%';
            percentageDisplay.textContent = Math.floor(this.currentProgress) + '%';
            
            // Update status based on progress
            this.updateStatus();
            
        }, 80 + Math.random() * 40); // Schnelleres interval für schnelleren Ladebalken
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
                    }, 1500);
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
            
        }, 5000);
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
        
        // Wait a bit then fade out
        setTimeout(() => {
            this.hideLoadingScreen();
        }, 5000); // 3 Sekunden länger (2s + 3s = 5s)
    }
    
    setupCursorVisibility() {
        // Alle interaktiven Elemente mit Pointer-Cursor versehen
        const interactiveElements = document.querySelectorAll(`
            .feature-item, .play-button, .mute-button, .volume-slider,
            .volume-control, .audio-controls, .loading-container,
            .status-container, .tips-container, .framework-features,
            .logo-container, .status-item, .loading-tip
        `);
        
        interactiveElements.forEach(element => {
            element.style.cursor = 'pointer';
            element.setAttribute('data-clickable', 'true');
        });
        
        // Body mit Standard-Cursor
        document.body.style.cursor = 'default';
        
        console.log('Mauszeiger-Sichtbarkeit aktiviert für', interactiveElements.length, 'Elemente');
    }
    
    hideLoadingScreen() {
        document.body.style.opacity = '0';
        document.body.style.transition = 'opacity 3s ease-out';
        
        setTimeout(() => {
            if (window.invokeNative) {
                window.invokeNative('shutdown');
            } else {
                console.log('Loading complete - shutting down');
            }
        }, 3000);
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

// Prevent F12 and other developer tools + Music control with spacebar
document.addEventListener('keydown', (e) => {
    // Music control with spacebar
    if (e.code === 'Space') {
        e.preventDefault(); // Verhindert Scrollen
        const audio = document.getElementById('backgroundMusic');
        if (audio && !audio.paused) {
            audio.pause();
            console.log('🔇 Musik gestoppt mit Leertaste');
        } else if (audio && audio.paused) {
            audio.play();
            console.log('🎵 Musik gestartet mit Leertaste');
        }
        return;
    }
    
    // Prevent developer tools
    if (e.key === 'F12' || 
        (e.ctrlKey && e.shiftKey && e.key === 'I') ||
        (e.ctrlKey && e.shiftKey && e.key === 'C') ||
        (e.ctrlKey && e.key === 'u')) {
        e.preventDefault();
    }
});