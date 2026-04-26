# Gruppo Bandistico Clesiano

Sito istituzionale statico generato con Jekyll e pubblicato tramite GitHub Pages.

## Struttura

- Le pagine sorgente restano nella root del repository: `index.html`, `chisiamo.html`, `media.html`, `concerti.html`, `trasparenza.html`, `contattaci.html`, `404.html`.
- La struttura comune del sito si trova in `_layouts/` e `_includes/`.
- La navigazione principale si modifica in `_data/navigation.yml`.
- CSS e immagini restano in `css/` e `images/`.
- `_site/` e' la cartella generata da Jekyll: non va committata.

## Sviluppo locale

Generare il sito:

```powershell
jekyll build
```

Avviare il server locale:

```powershell
bundle install
bundle exec jekyll serve
```

Con Ruby 3.x potrebbe essere necessario installare `webrick` una volta:

```powershell
gem install webrick
```

In alternativa, dopo `jekyll build`, si puo' aprire direttamente `_site/index.html`.

## Pubblicazione GitHub Pages

GitHub Pages deve pubblicare dalla root del branch. Non serve committare `_site/`: GitHub Pages esegue la build Jekyll e pubblica automaticamente l'output generato.
