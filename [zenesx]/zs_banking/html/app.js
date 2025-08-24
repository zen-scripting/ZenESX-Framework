// Banking UI JavaScript - Vollständig überarbeitet und korrigiert
(function() {
    'use strict';
    
    // Verhindere mehrfache Ausführung
    if (window.zsBankingInitialized) {
        console.log('ZS Banking bereits initialisiert, überspringe...');
        return;
    }
    window.zsBankingInitialized = true;
    
    // ========================================
    // VARIABLEN
    // ========================================
    let currentTab = 'overview';
    let playerData = null;
    let autoUpdateInterval = null;
    let currentLanguage = 'de'; // Default language

    // ========================================
    // LANGUAGE MANAGEMENT
    // ========================================
    // changeLanguage ist jetzt in der HTML definiert

    // updateUILanguage ist jetzt in der HTML definiert

    // ========================================
    // HELPER FUNCTIONS
    // ========================================
    function debugLog(message, data = null) {
        if (window.Config && window.Config.Debug && window.Config.Debug.enabled && window.Config.Debug.logging && window.Config.Debug.logging.banking) {
            console.log(`[ZS Banking Debug] ${message}`, data || '');
        }
    }

    function formatMoney(amount) {
        if (amount === undefined || amount === null) return '$0';
        return '$' + amount.toLocaleString();
    }

    function showNotification(message, type = 'info') {
        console.log(`[ZS Banking ${type.toUpperCase()}] ${message}`);
        
        // Benachrichtigung im UI anzeigen
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <span class="notification-message">${message}</span>
                <button class="notification-close" onclick="this.parentElement.parentElement.remove()">×</button>
            </div>
        `;
        
        // Benachrichtigung hinzufügen
        const container = document.getElementById('banking-container');
        if (container) {
            container.appendChild(notification);
            
            // Automatisch ausblenden nach 5 Sekunden
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 5000);
        }
    }

    function playSound(soundType) {
        try {
            // Einfache Sound-Implementierung mit verschiedenen Tönen
            let audioContext = window.audioContext;
            
            // AudioContext nur einmal erstellen
            if (!audioContext) {
                audioContext = new (window.AudioContext || window.webkitAudioContext)();
                window.audioContext = audioContext;
            }
            
            // Prüfe ob AudioContext suspended ist
            if (audioContext.state === 'suspended') {
                audioContext.resume();
            }
            
            const oscillator = audioContext.createOscillator();
            const gainNode = audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(audioContext.destination);
            
            // Verschiedene Töne für verschiedene Aktionen
            switch(soundType) {
                case 'button_click':
                    oscillator.frequency.setValueAtTime(800, audioContext.currentTime);
                    oscillator.type = 'sine';
                    break;
                case 'success':
                    oscillator.frequency.setValueAtTime(1000, audioContext.currentTime);
                    oscillator.type = 'sine';
                    break;
                case 'error':
                    oscillator.frequency.setValueAtTime(400, audioContext.currentTime);
                    oscillator.type = 'sawtooth';
                    break;
                case 'open':
                    oscillator.frequency.setValueAtTime(1200, audioContext.currentTime);
                    oscillator.type = 'sine';
                    break;
                case 'close':
                    oscillator.frequency.setValueAtTime(600, audioContext.currentTime);
                    oscillator.type = 'sine';
                    break;
                default:
                    oscillator.frequency.setValueAtTime(800, audioContext.currentTime);
                    oscillator.type = 'sine';
            }
            
            gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1);
            
            oscillator.start(audioContext.currentTime);
            oscillator.stop(audioContext.currentTime + 0.1);
            
        } catch (error) {
            console.warn('Sound konnte nicht abgespielt werden:', error);
        }
    }

    // ========================================
    // UI UPDATE FUNCTIONS
    // ========================================
    function updateUI() {
        debugLog('updateUI aufgerufen');
        if (!playerData) {
            debugLog('Keine Spielerdaten verfügbar für UI-Update');
            return;
        }
        
        debugLog('Aktualisiere UI mit Spielerdaten:', playerData);
        
        // Spielername aktualisieren - alle möglichen Element-IDs prüfen
        const playerNameElement = document.getElementById('overview-player-name');
        if (playerNameElement) {
            playerNameElement.textContent = `👤 ${playerData.name || 'UNBEKANNT'}`;
            debugLog('Spielername aktualisiert:', playerData.name);
        } else {
            debugLog('Spielername-Element nicht gefunden - ID: overview-player-name');
            // Alternative Suche
            const altPlayerNameElement = document.querySelector('[data-translate="player_name"]');
            if (altPlayerNameElement) {
                altPlayerNameElement.textContent = `👤 ${playerData.name || 'UNBEKANNT'}`;
                debugLog('Spielername über data-translate aktualisiert:', playerData.name);
            } else {
                debugLog('Kein Spielername-Element gefunden!');
            }
        }
        
        // Bargeld aktualisieren - alle möglichen Element-IDs prüfen
        const cashElement = document.getElementById('overview-cash-balance');
        if (cashElement) {
            cashElement.textContent = '💵 $' + (playerData.cash || 0).toLocaleString();
            debugLog('Bargeld aktualisiert:', playerData.cash);
        } else {
            debugLog('Bargeld-Element nicht gefunden - ID: overview-cash-balance');
        }
        
        // Bankkonto aktualisieren - alle möglichen Element-IDs prüfen
        const bankElement = document.getElementById('overview-bank-balance');
        if (bankElement) {
            bankElement.textContent = '🏦 $' + (playerData.bank || 0).toLocaleString();
            debugLog('Bankkonto aktualisiert:', playerData.bank);
        } else {
            debugLog('Bankkonto-Element nicht gefunden - ID: overview-bank-balance');
        }
        
        // Transaktionen laden wenn im transactions Tab
        if (currentTab === 'transactions') {
            loadTransactions();
        }
        
        debugLog('UI-Update abgeschlossen');
    }

    function updatePlayerDisplay() {
        debugLog('updatePlayerDisplay aufgerufen');
        // Aktualisiere Spielerdaten vom Server
        fetch(`https://${GetParentResourceName()}/getPlayerData`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                playerData = data.data;
                debugLog('Neue Spielerdaten vom Server erhalten:', playerData);
                updateUI();
            } else {
                debugLog('Fehler beim Laden der Spielerdaten:', data.error);
            }
        }).catch(error => {
            debugLog('Fehler beim Laden der Spielerdaten:', error);
        });
    }

    function loadTransactions() {
        debugLog('loadTransactions aufgerufen');
        if (!playerData || !playerData.transactions) {
            debugLog('Keine Spielerdaten oder Transaktionen verfügbar');
            return;
        }
        
        const transactionsList = document.getElementById('transactions-list');
        const noTransactions = document.getElementById('no-transactions');
        
        if (!transactionsList) {
            debugLog('Transaktionsliste-Element nicht gefunden');
            return;
        }
        
        debugLog('Lade Transaktionen:', playerData.transactions);
        
        // Alle Transaktionen entfernen
        transactionsList.innerHTML = '';
        
        if (playerData.transactions.length === 0) {
            if (noTransactions) {
                noTransactions.style.display = 'block';
            }
            debugLog('Keine Transaktionen verfügbar');
            return;
        }
        
        if (noTransactions) {
            noTransactions.style.display = 'none';
        }
        
        // Transaktionen anzeigen
        playerData.transactions.forEach(transaction => {
            const transactionElement = document.createElement('div');
            transactionElement.className = 'transaction-item';
            
            const icon = transaction.type === 'deposit' ? '💰' : 
                        transaction.type === 'withdraw' ? '💸' : 
                        transaction.type === 'transfer_sent' ? '🔄' :
                        transaction.type === 'transfer_received' ? '✅' : '🔄';
            
            transactionElement.innerHTML = `
                <div class="transaction-icon">${icon}</div>
                <div class="transaction-details">
                    <div class="transaction-type">${transaction.type}</div>
                    <div class="transaction-amount">$${transaction.amount}</div>
                    <div class="transaction-date">${transaction.date || 'Unbekannt'}</div>
                </div>
            `;
            
            transactionsList.appendChild(transactionElement);
            debugLog('Transaktion hinzugefügt:', transaction);
        });
        
        debugLog('Transaktionen geladen:', playerData.transactions.length);
    }

    // ========================================
    // CRYPTO FUNCTIONS
    // ========================================
    function loadCryptoData() {
        debugLog('Lade Crypto-Daten...');
        
        // Prüfe ob Crypto-Addon verfügbar ist
        if (window.Config && window.Config.AddonIntegration && window.Config.AddonIntegration.zs_crypto) {
            // Sende NUI-Callback um Crypto-Daten zu laden
            fetch(`https://${GetParentResourceName()}/getCryptoData`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            }).then(response => response.json())
            .then(data => {
                if (data.success) {
                    debugLog('Crypto-Daten werden geladen...');
                } else {
                    debugLog('Crypto-System nicht verfügbar:', data.error);
                    showNotification('Crypto-System ist nicht verfügbar', 'warning');
                }
            }).catch(error => {
                debugLog('Fehler beim Laden der Crypto-Daten:', error);
                showNotification('Fehler beim Laden der Crypto-Daten', 'error');
            });
        } else {
            debugLog('Crypto-Addon ist nicht konfiguriert');
            showNotification('Crypto-Addon ist nicht konfiguriert', 'warning');
        }
    }

    function buyCrypto() {
        const amountElement = document.getElementById('crypto-buy-amount');
        if (!amountElement) return;
        
        const amount = parseInt(amountElement.value);
        if (!amount || amount <= 0) {
            showNotification('Bitte geben Sie einen gültigen Betrag ein!', 'error');
            playSound('error');
            return;
        }
        
        playSound('button_click');
        
        fetch(`https://${GetParentResourceName()}/buyCrypto`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ 
                amount: amount,
                cryptoType: 'BTC' // Standardmäßig Bitcoin
            })
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Crypto erfolgreich gekauft!', 'success');
                playSound('success');
                amountElement.value = '';
                // Crypto-Daten neu laden
                setTimeout(() => {
                    loadCryptoData();
                }, 500);
            } else {
                showNotification('Fehler beim Kaufen von Crypto: ' + (data.error || 'Unbekannter Fehler'), 'error');
                playSound('error');
            }
        }).catch(error => {
            showNotification('Fehler beim Kaufen von Crypto!', 'error');
            playSound('error');
        });
    }

    function sellCrypto() {
        const amountElement = document.getElementById('crypto-sell-amount');
        if (!amountElement) return;
        
        const amount = parseFloat(amountElement.value);
        if (!amount || amount <= 0) {
            showNotification('Bitte geben Sie einen gültigen Crypto-Betrag ein!', 'error');
            playSound('error');
            return;
        }
        
        playSound('button_click');
        
        fetch(`https://${GetParentResourceName()}/sellCrypto`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ 
                amount: amount,
                cryptoType: 'BTC' // Standardmäßig Bitcoin
            })
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Crypto erfolgreich verkauft!', 'success');
                playSound('success');
                amountElement.value = '';
                // Crypto-Daten neu laden
                setTimeout(() => {
                    loadCryptoData();
                }, 500);
            } else {
                showNotification('Fehler beim Verkaufen von Crypto: ' + (data.error || 'Unbekannter Fehler'), 'error');
                playSound('error');
            }
        }).catch(error => {
            showNotification('Fehler beim Verkaufen von Crypto!', 'error');
            playSound('error');
        });
    }

    // ========================================
    // TAB MANAGEMENT
    // ========================================
    function switchTab(tabName) {
        // Alle Tabs ausblenden
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.style.display = 'none';
        });
        
        // Alle Tab-Buttons deaktivieren
        document.querySelectorAll('.tab-btn').forEach(button => {
            button.classList.remove('active');
        });
        
        // Gewählten Tab aktivieren
        const selectedTab = document.getElementById(tabName);
        const selectedButton = document.querySelector(`[onclick="switchTab('${tabName}')"]`);
        
        if (selectedTab) {
            selectedTab.style.display = 'block';
        }
        
        if (selectedButton) {
            selectedButton.classList.add('active');
        }
        
        currentTab = tabName;
        
        // Tab-spezifische Aktionen
        switch(tabName) {
            case 'overview':
                updateUI();
                break;
            case 'deposit':
                // Einzahlung Tab aktiviert
                break;
            case 'withdraw':
                // Abhebung Tab aktiviert
                break;
            case 'transfer':
                // Überweisung Tab aktiviert
                break;
            case 'transactions':
                loadTransactions();
                break;
            case 'crypto':
                // Crypto Tab aktiviert - lade Crypto-Daten
                loadCryptoData();
                break;
        }
    }

    // ========================================
    // BANKING FUNCTIONS
    // ========================================
    function deposit() {
        const amountElement = document.getElementById('deposit-amount');
        if (!amountElement) return;
        
        const amount = parseInt(amountElement.value);
        if (!amount || amount <= 0) {
            const message = window.getTranslation ? window.getTranslation('error_invalid_amount') : 'BITTE GEBEN SIE EINEN GÜLTIGEN BETRAG EIN!';
            showNotification(message, 'error');
            playSound('error');
            return;
        }
        
        playSound('button_click');
        
        fetch(`https://${GetParentResourceName()}/deposit`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ amount: amount })
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                const message = window.getTranslation ? window.getTranslation('success_deposit') : '💰 EINZAHLUNG ERFOLGREICH!';
                showNotification(message, 'success');
                playSound('success');
                
                // UI sofort aktualisieren
                setTimeout(() => {
                    updatePlayerDisplay();
                    // Auch Transaktionen neu laden
                    if (currentTab === 'transactions') {
                        loadTransactions();
                    }
                }, 500);
            } else {
                const errorMsg = window.getTranslation ? window.getTranslation('error_deposit_failed') : '❌ EINZAHLUNG FEHLGESCHLAGEN';
                const unknownError = window.getTranslation ? window.getTranslation('error_unknown') : 'Unbekannter Fehler';
                showNotification(errorMsg + ': ' + (data.error || unknownError), 'error');
                playSound('error');
            }
        }).catch(error => {
            const message = window.getTranslation ? window.getTranslation('error_deposit_failed') : '❌ EINZAHLUNG FEHLGESCHLAGEN!';
            showNotification(message, 'error');
            playSound('error');
        });
        
        amountElement.value = '';
    }

    function withdraw() {
        const amountElement = document.getElementById('withdraw-amount');
        if (!amountElement) return;
        
        const amount = parseInt(amountElement.value);
        if (!amount || amount <= 0) {
            const message = window.getTranslation ? window.getTranslation('error_invalid_amount') : 'BITTE GEBEN SIE EINEN GÜLTIGEN BETRAG EIN!';
            showNotification(message, 'error');
            playSound('error');
            return;
        }
        
        playSound('button_click');
        
        fetch(`https://${GetParentResourceName()}/withdraw`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ amount: amount })
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                const message = window.getTranslation ? window.getTranslation('success_withdraw') : '💸 ABHEBUNG ERFOLGREICH!';
                showNotification(message, 'success');
                playSound('success');
                
                // UI sofort aktualisieren
                setTimeout(() => {
                    updatePlayerDisplay();
                    // Auch Transaktionen neu laden
                    if (currentTab === 'transactions') {
                        loadTransactions();
                    }
                }, 500);
            } else {
                const errorMsg = window.getTranslation ? window.getTranslation('error_withdraw_failed') : '❌ ABHEBUNG FEHLGESCHLAGEN';
                const unknownError = window.getTranslation ? window.getTranslation('error_unknown') : 'Unbekannter Fehler';
                showNotification(errorMsg + ': ' + (data.error || unknownError), 'error');
                playSound('error');
            }
        }).catch(error => {
            const message = window.getTranslation ? window.getTranslation('error_withdraw_failed') : '❌ ABHEBUNG FEHLGESCHLAGEN!';
            showNotification(message, 'error');
            playSound('error');
        });
        
        amountElement.value = '';
    }

    function transfer() {
        const playerIdElement = document.getElementById('transfer-player');
        const amountElement = document.getElementById('transfer-amount');
        
        if (!playerIdElement || !amountElement) return;
        
        const playerId = parseInt(playerIdElement.value);
        const amount = parseInt(amountElement.value);
        
        if (!playerId || playerId <= 0) {
            const message = window.getTranslation ? window.getTranslation('error_invalid_player_id') : 'BITTE GEBEN SIE EINE GÜLTIGE SPIELER-ID EIN!';
            showNotification(message, 'error');
            playSound('error');
            return;
        }
        
        if (!amount || amount <= 0) {
            const message = window.getTranslation ? window.getTranslation('error_invalid_amount') : 'BITTE GEBEN SIE EINEN GÜLTIGEN BETRAG EIN!';
            showNotification(message, 'error');
            playSound('error');
            return;
        }
        
        playSound('button_click');
        
        fetch(`https://${GetParentResourceName()}/transfer`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ 
                target: playerId, 
                amount: amount,
                reason: 'Überweisung'
            })
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                const message = window.getTranslation ? window.getTranslation('success_transfer') : '🔄 ÜBERWEISUNG ERFOLGREICH!';
                showNotification(message, 'success');
                playSound('success');
                
                // UI sofort aktualisieren
                setTimeout(() => {
                    updatePlayerDisplay();
                    // Auch Transaktionen neu laden
                    if (currentTab === 'transactions') {
                        loadTransactions();
                    }
                }, 500);
            } else {
                const errorMsg = window.getTranslation ? window.getTranslation('error_transfer_failed') : '❌ ÜBERWEISUNG FEHLGESCHLAGEN';
                const unknownError = window.getTranslation ? window.getTranslation('error_unknown') : 'Unbekannter Fehler';
                showNotification(errorMsg + ': ' + (data.error || unknownError), 'error');
                playSound('error');
            }
        }).catch(error => {
            const message = window.getTranslation ? window.getTranslation('error_transfer_failed') : '❌ ÜBERWEISUNG FEHLGESCHLAGEN!';
            showNotification(message, 'error');
            playSound('error');
        });
        
        playerIdElement.value = '';
        amountElement.value = '';
    }

    // ========================================
    // EVENT LISTENERS
    // ========================================
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        debugLog('NUI Message empfangen:', data);
        
        switch(data.action) {
            case 'openBanking':
                debugLog('Öffne Banking UI...');
                
                const container = document.getElementById('banking-container');
                if (container) {
                    container.classList.remove('hidden');
                    debugLog('Banking Container angezeigt');
                } else {
                    debugLog('Banking Container nicht gefunden!');
                }
                
                // Spielerdaten setzen
                playerData = {
                    cash: data.cash || 0,
                    bank: data.bank || 0,
                    name: data.name || 'UNBEKANNT',
                    transactions: data.transactions || [],
                    bankName: data.bankName || '🏦 ZS BANKING SYSTEM'
                };
                
                debugLog('Spielerdaten gesetzt:', playerData);
                
                // Debug-Config setzen
                if (data.debug) {
                    window.Config = { Debug: data.debug };
                    debugLog('Debug-Config geladen:', window.Config.Debug);
                }
                
                // Locales laden
                if (data.locales) {
                    window.Locales = data.locales;
                    debugLog('Locales geladen:', Object.keys(data.locales));
                }
                
                // Sprache setzen - Priorität: data.language > Config.Language > Standard
                let targetLanguage = 'de';
                
                if (data.language) {
                    targetLanguage = data.language;
                    debugLog('Sprache aus NUI-Daten:', targetLanguage);
                } else if (window.Config && window.Config.Language) {
                    targetLanguage = window.Config.Language;
                    debugLog('Sprache aus Config:', targetLanguage);
                }
                
                currentLanguage = targetLanguage;
                debugLog('Sprache gesetzt:', currentLanguage);
                
                // UI aktualisieren
                debugLog('Starte UI-Update...');
                updateUI();
                
                // Übersetzungen sofort anwenden
                if (typeof changeLanguage === 'function') {
                    changeLanguage(currentLanguage);
                } else {
                    debugLog('changeLanguage Funktion nicht verfügbar');
                }
                
                debugLog('Banking UI erfolgreich geöffnet');
                break;
                
            case 'updatePlayerData':
                debugLog('Update Player Data empfangen:', data);
                playerData = data;
                debugLog('Neue Spielerdaten gesetzt:', playerData);
                updateUI();
                break;
                
            case 'updateBalances':
                debugLog('Update Balances empfangen:', data);
                if (playerData) {
                    playerData.cash = data.cash;
                    playerData.bank = data.bank;
                    debugLog('Balances aktualisiert - Cash:', data.cash, 'Bank:', data.bank);
                    updateUI();
                } else {
                    debugLog('Keine Spielerdaten für Balance-Update');
                }
                break;
                
            case 'updateTransactions':
                debugLog('Update Transactions empfangen:', data);
                if (playerData) {
                    playerData.transactions = data.transactions || [];
                    debugLog('Transaktionen aktualisiert:', playerData.transactions);
                    // Transaktionen sofort laden wenn im transactions Tab
                    if (currentTab === 'transactions') {
                        loadTransactions();
                    }
                } else {
                    debugLog('Keine Spielerdaten für Transaction-Update');
                }
                break;
                
            case 'showNotification':
                showNotification(data.message, data.type);
                break;
                
            case 'playSound':
                playSound(data.sound);
                break;
                
            case 'closeBanking':
                debugLog('Schließe Banking UI...');
                const bankingContainer = document.getElementById('banking-container');
                if (bankingContainer) {
                    bankingContainer.classList.add('hidden');
                }
                break;
                
            default:
                debugLog('Unbekannte NUI-Aktion:', data.action);
        }
    });

    // ========================================
    // INITIALIZATION
    // ========================================
    document.addEventListener('DOMContentLoaded', function() {
        debugLog('DOM geladen, initialisiere Banking UI...');
        
        // Standard-Tab aktivieren
        switchTab('overview');
        
        // Event Listener für Tab-Buttons
        document.querySelectorAll('.tab-button').forEach(button => {
            button.addEventListener('click', function() {
                const tabName = this.getAttribute('data-tab');
                if (tabName) {
                    switchTab(tabName);
                }
            });
        });
        
        // Event Listener für Banking-Buttons
        const depositBtn = document.getElementById('deposit-btn');
        if (depositBtn) {
            depositBtn.addEventListener('click', deposit);
        }
        
        const withdrawBtn = document.getElementById('withdraw-btn');
        if (withdrawBtn) {
            withdrawBtn.addEventListener('click', withdraw);
        }
        
        const transferBtn = document.getElementById('transfer-btn');
        if (transferBtn) {
            transferBtn.addEventListener('click', transfer);
        }
        
        // Event Listener für Schließen-Button
        const closeBtn = document.getElementById('close-btn');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                fetch(`https://${GetParentResourceName()}/closeBanking`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({})
                });
            });
        }
        
        debugLog('Banking UI erfolgreich initialisiert');
    });

    // ========================================
    // EXPORT FUNCTIONS
    // ========================================
    window.zsBanking = {
        changeLanguage: function(lang) {
            if (typeof changeLanguage === 'function') {
                changeLanguage(lang);
            }
        },
        updateUI: updateUI,
        deposit: deposit,
        withdraw: withdraw,
        transfer: transfer,
        switchTab: switchTab
    };

})();


