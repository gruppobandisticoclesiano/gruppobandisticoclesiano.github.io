# Gruppo Bandistico Clesiano

Repository del sito istituzionale del Gruppo Bandistico Clesiano APS.

Il sito e' generato con [Jekyll](https://jekyllrb.com/) e pubblicato tramite GitHub Pages. 

## Struttura del progetto

```text
.
├── _config.yml              Configurazione generale del sito
├── _data/                   Contenuti strutturati in YAML
├── _includes/               Componenti HTML riutilizzabili
├── _layouts/                Layout Jekyll condivisi
├── css/                     Fogli di stile delle pagine
├── images/                  Immagini e locandine
├── index.html               Home page
├── chisiamo.html            Pagina "Chi siamo"
├── concerti.html            Pagina concerti
├── media.html               Pagina media
├── trasparenza.html         Pagina trasparenza
├── contattaci.html          Pagina contatti
└── 404.html                 Pagina di errore
```

## Contenuti modificabili

I contenuti ripetuti sono stati spostati in `_data/`, in modo da evitare duplicazione di HTML.

| File | Contenuto |
| --- | --- |
| `_data/navigation.yml` | Voci del menu principale |
| `_data/timeline.yml` | Timeline storica della pagina "Chi siamo" |
| `_data/concerts.yml` | Locandine e dati della pagina concerti |
| `_data/media_gallery.yml` | Immagini della pagina media |
| `_data/transparency.yml` | Dati della pagina trasparenza |

Per aggiornare una pagina, quando possibile, modificare prima il relativo file YAML in `_data/`. Le pagine `.html` dovrebbero contenere soprattutto struttura, sezioni e richiami agli include.

## Sviluppo locale

Installare le dipendenze Ruby:

```powershell
bundle install
```

Generare il sito:

```powershell
bundle exec jekyll build
```

Avviare un server locale con rigenerazione automatica:

```powershell
bundle exec jekyll serve
```

Il sito sara' disponibile di norma all'indirizzo:

```text
http://127.0.0.1:4000/
```

Con Ruby 3.x potrebbe essere necessario installare `webrick` una volta:

```powershell
gem install webrick
```

## Ottimizzazione immagini

Per generare versioni WebP delle immagini del sito da PowerShell:

```powershell
.\scripts\convert-images-to-webp.cmd
```

Lo script converte i file `.jpg`, `.jpeg` e `.png` dentro `images/`, creando un file `.webp` accanto all'originale. Se il WebP esiste gia' ed e' piu' recente dell'originale viene saltato.

Opzioni utili:

```powershell
.\scripts\convert-images-to-webp.cmd -Quality 78
.\scripts\convert-images-to-webp.cmd -Force
.\scripts\convert-images-to-webp.cmd -WhatIf
```

Lo script usa `cwebp` se disponibile, altrimenti `ffmpeg`.

Se si preferisce lanciare direttamente il file `.ps1`, PowerShell potrebbe bloccarlo per policy di sicurezza. In quel caso usare:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Convert-ImagesToWebP.ps1
```

## Pubblicazione

GitHub Pages deve pubblicare dalla root del branch configurato per il sito.

 Nel repository vanno committati solo i sorgenti, cioe' pagine, layout, include, dati, CSS, immagini e configurazione.

## Convenzioni

- Usare percorsi assoluti Jekyll con `{{ site.baseurl }}` o percorsi root-relative dove gia' adottati.
- Tenere i contenuti strutturati in YAML quando una sezione contiene liste, date, immagini o righe tabellari.
- Non duplicare blocchi HTML complessi se possono essere gestiti con un include.
