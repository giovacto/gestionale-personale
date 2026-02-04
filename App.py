from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'chiave_segreta_super_sicura'

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'gestionale_dati'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

# --- 1. AUTENTICAZIONE ---

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nome = request.form['nome']
        email = request.form['email']
        password = generate_password_hash(request.form['password'])
        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("INSERT INTO utenti (nome, email, password, attivo) VALUES (%s, %s, %s, 0)", 
                           (nome, email, password))
            conn.commit()
            flash('Registrazione inviata! Attendi abilitazione.', 'info')
            return redirect(url_for('login'))
        except mysql.connector.Error as err:
            flash(f'Errore: {err}', 'danger')
        finally:
            cursor.close(); conn.close()
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM utenti WHERE email = %s", (email,))
        user = cursor.fetchone()
        cursor.close(); conn.close()
        if user and check_password_hash(user['password'], password):
            if user['attivo'] == 1:
                session['user_id'] = user['id']
                session['user_name'] = user['nome']
                session['ruolo'] = user['ruolo']
                flash(f'Benvenuto, {user["nome"]}!', 'success')
                return redirect(url_for('home'))
            else:
                flash('Account non attivo.', 'warning')
        else:
            flash('Credenziali errate.', 'danger')
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('Disconnesso.', 'info')
    return redirect(url_for('login'))

# --- 2. DASHBOARD ---

@app.route('/')
def home():
    if 'user_id' not in session: return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # 1. Statistiche Spese del mese corrente
    cursor.execute("""
        SELECT 
            IFNULL(SUM(costo), 0) as tot_costi, 
            IFNULL(SUM(incassato), 0) as tot_incassi 
        FROM prima_nota 
        WHERE MONTH(data) = MONTH(CURRENT_DATE()) 
        AND YEAR(data) = YEAR(CURRENT_DATE())
    """)
    stats_spese = cursor.fetchone()

    # 2. Conteggio Interventi ultimi 30 giorni (divisi per tipo)
    cursor.execute("""
        SELECT 
            SUM(CASE WHEN is_chiamata = 1 THEN 1 ELSE 0 END) as chiamate,
            SUM(CASE WHEN is_chiamata = 0 THEN 1 ELSE 0 END) as attivita
        FROM interventi 
        WHERE data_intervento >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
    """)
    stats_interventi = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template('home.html', 
                           spese=stats_spese, 
                           interventi=stats_interventi)

# --- 3. CLIENTI ---

@app.route('/clienti', methods=['GET', 'POST'])
def clienti():
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        try:
            cursor.execute("""
                INSERT INTO anagrafiche (ragione_sociale, nome, cognome, codice_fiscale, email, cellulare, id_utente) 
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (request.form['ragione_sociale'], request.form['nome'], request.form['cognome'], 
                  request.form['codice_fiscale'].upper(), request.form['email'], request.form['cellulare'], session['user_id']))
            conn.commit()
            flash('Cliente inserito!', 'success')
        except mysql.connector.Error as err:
            flash(f'Errore: {err}', 'danger')
    if session['ruolo'] == 'admin':
        cursor.execute("SELECT * FROM anagrafiche ORDER BY ragione_sociale")
    else:
        cursor.execute("SELECT * FROM anagrafiche WHERE id_utente = %s ORDER BY ragione_sociale", (session['user_id'],))
    data = cursor.fetchall()
    cursor.close(); conn.close()
    return render_template('clienti.html', anagrafiche=data)

@app.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit(id):
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        cursor.execute("UPDATE anagrafiche SET ragione_sociale=%s, nome=%s, cognome=%s, codice_fiscale=%s, email=%s, cellulare=%s WHERE id=%s",
                       (request.form['ragione_sociale'], request.form['nome'], request.form['cognome'], request.form['codice_fiscale'].upper(), request.form['email'], request.form['cellulare'], id))
        conn.commit(); cursor.close(); conn.close()
        flash('Modifica salvata!', 'success')
        return redirect(url_for('clienti'))
    cursor.execute("SELECT * FROM anagrafiche WHERE id=%s", (id,))
    row = cursor.fetchone()
    cursor.close(); conn.close()
    return render_template('edit.html', row=row)

@app.route('/delete/<int:id>')
def delete(id):
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM anagrafiche WHERE id=%s", (id,))
    conn.commit(); cursor.close(); conn.close()
    flash('Cliente eliminato.', 'warning')
    return redirect(url_for('clienti'))

# --- 4. STAFF (LA SEZIONE CHE MANCAVA) ---

@app.route('/staff', methods=['GET', 'POST'])
def staff():
    if 'user_id' not in session or session.get('ruolo') != 'admin':
        flash('Accesso riservato agli amministratori.', 'danger')
        return redirect(url_for('home'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        cursor.execute("INSERT INTO staff (nome, cognome, email, cellulare) VALUES (%s, %s, %s, %s)", 
                       (request.form['nome'], request.form['cognome'], request.form['email'], request.form['cellulare']))
        conn.commit()
        flash('Staff aggiunto!', 'success')
    cursor.execute("SELECT * FROM staff ORDER BY cognome")
    staff_list = cursor.fetchall()
    cursor.close(); conn.close()
    return render_template('staff.html', staff_list=staff_list)

@app.route('/delete_staff/<int:id>')
def delete_staff(id):
    if session.get('ruolo') != 'admin': return redirect(url_for('home'))
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM staff WHERE id = %s", (id,))
    conn.commit(); cursor.close(); conn.close()
    flash('Membro staff rimosso.', 'warning')
    return redirect(url_for('staff'))

# --- 5. INTERVENTI ---

@app.route('/interventi', methods=['GET', 'POST'])
def interventi():
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        is_chiamata = 1 if request.form.get('is_chiamata') else 0
        cursor.execute("""
            INSERT INTO interventi (data_intervento, id_staff, id_anagrafica, descrizione, link_documento, is_chiamata)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (request.form['data'], request.form['id_staff'], request.form['id_anagrafica'], 
              request.form['descrizione'], request.form['link'], is_chiamata))
        conn.commit()
        flash('Intervento registrato!', 'success')
        return redirect(url_for('interventi'))
    cursor.execute("SELECT id, nome, cognome FROM staff ORDER BY cognome")
    st = cursor.fetchall()
    cursor.execute("SELECT id, ragione_sociale FROM anagrafiche ORDER BY ragione_sociale")
    an = cursor.fetchall()
    cursor.execute("""
        SELECT i.*, s.nome AS staff_nome, s.cognome AS staff_cognome, a.ragione_sociale AS cliente_nome
        FROM interventi i JOIN staff s ON i.id_staff = s.id JOIN anagrafiche a ON i.id_anagrafica = a.id
        WHERE i.stato = 0 ORDER BY i.data_intervento DESC
    """)
    el = cursor.fetchall()
    cursor.close(); conn.close()
    return render_template('interventi.html', staffs=st, anagrafiche=an, interventi=el)

@app.route('/chiudi_intervento/<int:id>')
def chiudi_intervento(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE interventi SET stato = 1 WHERE id = %s", (id,))
    conn.commit(); cursor.close(); conn.close()
    return redirect(url_for('interventi'))

@app.route('/toggle_tipo_intervento/<int:id>')
def toggle_tipo_intervento(id):
    if 'user_id' not in session: return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # 1. Recupero lo stato attuale
    cursor.execute("SELECT is_chiamata FROM interventi WHERE id = %s", (id,))
    intervento = cursor.fetchone()
    
    if intervento:
        # 2. Inverto lo stato (se 1 diventa 0, se 0 diventa 1)
        nuovo_stato = 0 if intervento['is_chiamata'] == 1 else 1
        cursor.execute("UPDATE interventi SET is_chiamata = %s WHERE id = %s", (nuovo_stato, id))
        conn.commit()
    
    cursor.close(); conn.close()
    return redirect(url_for('interventi'))

# --- 6. SPESE (PRIMA NOTA) - AGGIORNATO CON STAFF ---
@app.route('/spese', methods=['GET', 'POST'])
def spese():
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        try:
            cursor.execute("""
                INSERT INTO prima_nota (data, costo, incassato, id_categoria, id_pagamento, descrizione, id_staff)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (request.form['data'], request.form.get('costo') or 0, request.form.get('incassato') or 0, 
                  request.form['id_categoria'], request.form['id_pagamento'], request.form['descrizione'], 
                  request.form.get('id_staff') if request.form.get('id_staff') else None))
            conn.commit()
            flash('Registrato!', 'success')
            return redirect(url_for('spese'))
        except Exception as e:
            flash(f"Errore durante l'inserimento: {e}", "danger")

    # Caricamento liste per i menu
    cursor.execute("SELECT id, nome, cognome FROM staff ORDER BY cognome")
    staff_list = cursor.fetchall()
    cursor.execute("SELECT * FROM categorie_acquisto ORDER BY nome_categoria")
    cats = cursor.fetchall()
    cursor.execute("SELECT * FROM tipologie_pagamento ORDER BY descrizione")
    pags = cursor.fetchall()
    
    # Query tabella
    cursor.execute("""
        SELECT pn.*, c.nome_categoria, p.descrizione as metodo_pagamento, s.cognome as staff_cognome
        FROM prima_nota pn 
        LEFT JOIN categorie_acquisto c ON pn.id_categoria = c.id
        LEFT JOIN tipologie_pagamento p ON pn.id_pagamento = p.id 
        LEFT JOIN staff s ON pn.id_staff = s.id
        ORDER BY pn.data DESC
    """)
    movs = cursor.fetchall()
    
    # Calcolo totali con protezione contro i valori None
    tc = sum(float(m['costo'] or 0) for m in movs)
    ti = sum(float(m['incassato'] or 0) for m in movs)
    
    cursor.close(); conn.close()
    return render_template('spese.html', categorie=cats, pagamenti=pags, staff=staff_list, movimenti=movs, 
                           tot_costi=tc, tot_incassi=ti, saldo=ti-tc)

# --- EDIT SPESA - AGGIORNATO CON STAFF E DESCRIZIONE ---
@app.route('/edit_spesa/<int:id>', methods=['GET', 'POST'])
def edit_spesa(id):
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        try:
            # AGGIORNATO: Ora salviamo anche id_staff e la descrizione
            cursor.execute("""
                UPDATE prima_nota 
                SET data=%s, costo=%s, incassato=%s, id_categoria=%s, id_pagamento=%s, descrizione=%s, id_staff=%s 
                WHERE id=%s
            """, (
                request.form['data'], 
                request.form['costo'], 
                request.form['incassato'], 
                request.form['id_categoria'], 
                request.form['id_pagamento'], 
                request.form['descrizione'],
                request.form.get('id_staff') if request.form.get('id_staff') else None,
                id
            ))
            conn.commit()
            flash('Movimento aggiornato con successo!', 'success')
            return redirect(url_for('reports_hub'))
        except mysql.connector.Error as err:
             flash(f'Errore durante il salvataggio: {err}', 'danger')

    # Recupero i dati del movimento da modificare
    cursor.execute("SELECT * FROM prima_nota WHERE id = %s", (id,))
    movimento = cursor.fetchone()
    
    # AGGIORNATO: Carichiamo lo staff per il menu a tendina
    cursor.execute("SELECT id, nome, cognome FROM staff ORDER BY cognome")
    staff_list = cursor.fetchall()
    
    # Recupero liste per categorie e pagamenti
    cursor.execute("SELECT * FROM categorie_acquisto ORDER BY nome_categoria")
    cats = cursor.fetchall()
    cursor.execute("SELECT * FROM tipologie_pagamento ORDER BY descrizione")
    pags = cursor.fetchall()
    
    cursor.close(); conn.close()
    
    # Passiamo anche 'staff=staff_list' al template
    return render_template('edit_spesa.html', 
                           mov=movimento, 
                           categorie=cats, 
                           pagamenti=pags, 
                           staff=staff_list)

# --- FUNZIONE PER ELIMINARE UNA SPESA (Mancante) ---
@app.route('/delete_spesa/<int:id>')
def delete_spesa(id):
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM prima_nota WHERE id = %s", (id,))
        conn.commit()
        flash('Movimento eliminato correttamente.', 'warning')
    except Exception as e:
        flash(f"Errore durante l'eliminazione: {e}", "danger")
    finally:
        cursor.close()
        conn.close()
    return redirect(url_for('spese'))
# --- 7. CONFIGURAZIONE SPESE ---

@app.route('/config_spese', methods=['GET', 'POST'])
def config_spese():
    # 1. Controllo sicurezza admin
    if 'user_id' not in session or session.get('ruolo') != 'admin':
        flash("Accesso negato. Solo gli amministratori possono accedere.", "danger")
        return redirect(url_for('home'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        # --- LOGICA AGGIUNTA CATEGORIA ---
        if 'add_categoria' in request.form:
            nuovo_nome = request.form.get('nome_categoria').strip()
            nuovo_nome_lower = nuovo_nome.lower()
            
            # Recupero categorie esistenti per il confronto
            cursor.execute("SELECT nome_categoria FROM categorie_acquisto")
            esistenti = cursor.fetchall()
            
            procedi = True
            for cat in esistenti:
                nome_db = cat['nome_categoria'].lower()
                
                # Controllo duplicato esatto
                if nome_db == nuovo_nome_lower:
                    flash(f"Errore: La categoria '{nuovo_nome}' esiste già.", "danger")
                    procedi = False
                    break
                
                # Controllo similitudine (parole > 3 lettere)
                parole = nuovo_nome_lower.split()
                for p in parole:
                    if len(p) > 3 and p in nome_db:
                        flash(f"Avviso: '{nuovo_nome}' è simile a '{cat['nome_categoria']}'.", "warning")
            
            if procedi:
                cursor.execute("INSERT INTO categorie_acquisto (nome_categoria) VALUES (%s)", (nuovo_nome,))
                conn.commit()
                flash(f"Categoria '{nuovo_nome}' aggiunta!", "success")

        # --- LOGICA AGGIUNTA METODO PAGAMENTO ---
        elif 'add_pagamento' in request.form:
            nuova_desc = request.form.get('descrizione_pagamento').strip()
            nuova_desc_lower = nuova_desc.lower()
            
            cursor.execute("SELECT descrizione FROM tipologie_pagamento")
            esistenti_pag = cursor.fetchall()
            
            procedi_pag = True
            for pag in esistenti_pag:
                if pag['descrizione'].lower() == nuova_desc_lower:
                    flash(f"Il metodo '{nuova_desc}' esiste già.", "danger")
                    procedi_pag = False
                    break
            
            if procedi_pag:
                cursor.execute("INSERT INTO tipologie_pagamento (descrizione) VALUES (%s)", (nuova_desc,))
                conn.commit()
                flash(f"Metodo '{nuova_desc}' aggiunto!", "success")

        cursor.close(); conn.close()
        return redirect(url_for('config_spese'))

    # Caricamento dati per la visualizzazione (GET)
    cursor.execute("SELECT * FROM categorie_acquisto ORDER BY nome_categoria")
    cats = cursor.fetchall()
    cursor.execute("SELECT * FROM tipologie_pagamento ORDER BY descrizione")
    pags = cursor.fetchall()
    
    cursor.close(); conn.close()
    return render_template('config_spese.html', categorie=cats, pagamenti=pags)

@app.route('/delete_categoria/<int:id>')
def delete_categoria(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM categorie_acquisto WHERE id=%s", (id,))
        conn.commit()
    except:
        flash('In uso!', 'danger')
    cursor.close(); conn.close()
    return redirect(url_for('config_spese'))

@app.route('/edit_categoria/<int:id>', methods=['GET', 'POST'])
def edit_categoria(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        cursor.execute("UPDATE categorie_acquisto SET nome_categoria=%s WHERE id=%s", (request.form['nome'], id))
        conn.commit(); cursor.close(); conn.close()
        return redirect(url_for('config_spese'))
    cursor.execute("SELECT * FROM categorie_acquisto WHERE id=%s", (id,))
    c = cursor.fetchone()
    cursor.close(); conn.close()
    return render_template('edit_categoria.html', cat=c)

@app.route('/delete_pagamento/<int:id>')
def delete_pagamento(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM tipologie_pagamento WHERE id=%s", (id,))
        conn.commit()
    except:
        flash('In uso!', 'danger')
    cursor.close(); conn.close()
    return redirect(url_for('config_spese'))

@app.route('/edit_pagamento/<int:id>', methods=['GET', 'POST'])
def edit_pagamento(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if request.method == 'POST':
        cursor.execute("UPDATE tipologie_pagamento SET descrizione=%s WHERE id=%s", (request.form['desc'], id))
        conn.commit(); cursor.close(); conn.close()
        return redirect(url_for('config_spese'))
    cursor.execute("SELECT * FROM tipologie_pagamento WHERE id=%s", (id,))
    p = cursor.fetchone()
    cursor.close(); conn.close()
    return render_template('edit_pagamento.html', pag=p)

# --- 8. HUB DEI REPORT ---

@app.route('/reports')
def reports_hub():
    if 'user_id' not in session: return redirect(url_for('login'))
    return render_template('reports_hub.html')

# --- 9. REPORT INTERVENTI - AGGIORNATO CON FILTRI ---
@app.route('/report_interventi', methods=['GET', 'POST'])
def report_interventi():
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection(); cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, ragione_sociale FROM anagrafiche ORDER BY ragione_sociale")
    lista_clienti = cursor.fetchall()
    
    risultati = []; filtri_attivi = False
    if request.method == 'POST':
        filtri_attivi = True
        query = """
            SELECT i.*, s.nome AS staff_nome, s.cognome AS staff_cognome, a.ragione_sociale AS cliente_nome 
            FROM interventi i JOIN staff s ON i.id_staff = s.id 
            JOIN anagrafiche a ON i.id_anagrafica = a.id WHERE 1=1
        """
        params = []
        if request.form.get('id_cliente'):
            query += " AND i.id_anagrafica = %s"; params.append(request.form.get('id_cliente'))
        if request.form.get('data_da'):
            query += " AND i.data_intervento >= %s"; params.append(request.form.get('data_da'))
        if request.form.get('data_a'):
            query += " AND i.data_intervento <= %s"; params.append(request.form.get('data_a'))
        
        # Filtro Stato (Aperto/Chiuso)
        stato = request.form.get('stato')
        if stato in ['0', '1']:
            query += " AND i.stato = %s"; params.append(stato)
            
        # Filtro Descrizione Parziale
        desc = request.form.get('descrizione')
        if desc:
            query += " AND i.descrizione LIKE %s"; params.append(f"%{desc}%")
            
        query += " ORDER BY i.data_intervento DESC"
        cursor.execute(query, params); risultati = cursor.fetchall()
        
    cursor.close(); conn.close()
    return render_template('report_interventi.html', clienti=lista_clienti, report=risultati, filtri_attivi=filtri_attivi)

# --- 10. REPORT PRIMA NOTA - AGGIORNATO CON FILTRI ---
@app.route('/report_prima_nota', methods=['GET', 'POST'])
def report_prima_nota():
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection(); cursor = conn.cursor(dictionary=True)
    
    # Recupero liste per i filtri
    cursor.execute("SELECT * FROM categorie_acquisto ORDER BY nome_categoria")
    categorie = cursor.fetchall()
    cursor.execute("SELECT * FROM tipologie_pagamento ORDER BY descrizione")
    pagamenti = cursor.fetchall()
    # Recupero lo staff per il nuovo filtro
    cursor.execute("SELECT id, nome, cognome FROM staff ORDER BY cognome")
    staff_list = cursor.fetchall()

    risultati = []; filtri_attivi = False; tot_uscita = 0; tot_entrata = 0
    dati_grafico = {}

    if request.method == 'POST':
        filtri_attivi = True
        # LEFT JOIN su staff permette di vedere anche i record con id_staff vuoto
        query = """
            SELECT pn.*, c.nome_categoria, p.descrizione as metodo_pagamento, 
                   s.nome as staff_nome, s.cognome as staff_cognome
            FROM prima_nota pn 
            LEFT JOIN categorie_acquisto c ON pn.id_categoria = c.id 
            LEFT JOIN tipologie_pagamento p ON pn.id_pagamento = p.id 
            LEFT JOIN staff s ON pn.id_staff = s.id
            WHERE 1=1
        """
        params = []
        if request.form.get('id_categoria'):
            query += " AND pn.id_categoria = %s"; params.append(request.form.get('id_categoria'))
        if request.form.get('id_pagamento'):
            query += " AND pn.id_pagamento = %s"; params.append(request.form.get('id_pagamento'))
        
        # NUOVO: Filtro Staff
        if request.form.get('id_staff'):
            query += " AND pn.id_staff = %s"; params.append(request.form.get('id_staff'))
            
        # NUOVO: Filtro Descrizione (Ricerca Parziale)
        desc_filtro = request.form.get('descrizione')
        if desc_filtro:
            query += " AND pn.descrizione LIKE %s"
            params.append(f"%{desc_filtro}%")
            
        if request.form.get('data_da'):
            query += " AND pn.data >= %s"; params.append(request.form.get('data_da'))
        if request.form.get('data_a'):
            query += " AND pn.data <= %s"; params.append(request.form.get('data_a'))
        
        query += " ORDER BY pn.data DESC"
        cursor.execute(query, params); risultati = cursor.fetchall()
        
        for r in risultati:
            costo_val = float(r['costo'])
            tot_uscita += costo_val
            tot_entrata += float(r['incassato'])
            if costo_val > 0:
                cat_nome = r['nome_categoria'] or "Non specificata"
                dati_grafico[cat_nome] = dati_grafico.get(cat_nome, 0) + costo_val

    cursor.close(); conn.close()
    
    labels_grafico = list(dati_grafico.keys())
    valori_grafico = list(dati_grafico.values())

    return render_template('report_prima_nota.html', 
                           categorie=categorie, pagamenti=pagamenti, staff_list=staff_list,
                           report=risultati, filtri_attivi=filtri_attivi,
                           tot_uscita=tot_uscita, tot_entrata=tot_entrata,
                           labels_pie=labels_grafico, valori_pie=valori_grafico)

@app.route('/edit_intervento/<int:id>', methods=['GET', 'POST'])
def edit_intervento(id):
    if 'user_id' not in session: return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        try:
            is_chiamata = 1 if request.form.get('is_chiamata') else 0
            # Gestisce il flag dello stato (0 aperto, 1 chiuso)
            stato = 1 if request.form.get('stato') else 0
            
            cursor.execute("""
                UPDATE interventi 
                SET data_intervento=%s, id_staff=%s, id_anagrafica=%s, 
                    descrizione=%s, link_documento=%s, is_chiamata=%s, stato=%s
                WHERE id=%s
            """, (
                request.form['data'], 
                request.form['id_staff'], 
                request.form['id_anagrafica'], 
                request.form['descrizione'], 
                request.form['link'],
                is_chiamata,
                stato,
                id
            ))
            conn.commit()
            flash('Intervento aggiornato con successo!', 'success')
            return redirect(url_for('report_interventi'))
        except mysql.connector.Error as err:
             flash(f'Errore: {err}', 'danger')
        finally:
            cursor.close(); conn.close()

    cursor.execute("SELECT * FROM interventi WHERE id = %s", (id,))
    intervento = cursor.fetchone()
    cursor.execute("SELECT id, nome, cognome FROM staff ORDER BY cognome")
    staff_list = cursor.fetchall()
    cursor.execute("SELECT id, ragione_sociale FROM anagrafiche ORDER BY ragione_sociale")
    clienti_list = cursor.fetchall()
    cursor.close(); conn.close()
    
    return render_template('edit_intervento.html', intervento=intervento, staffs=staff_list, anagrafiche=clienti_list)

if __name__ == '__main__':
    app.run(debug=True)