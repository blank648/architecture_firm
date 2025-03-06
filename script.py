import oracledb

#configuram conexiunea
HOSTNAME = "localhost"
PORT = 1521
SID = "xe"
USERNAME = "utilizator"
PASSWORD = "parola"
DSN = f"{HOSTNAME}:{PORT}/{SID}"


def connect_to_db():
    """Conectează-te la baza de date și returnează conexiunea."""
    try:
        conn = oracledb.connect(
            user=USERNAME,
            password=PASSWORD,
            dsn=DSN
        )
        print("Conexiune reușită!")
        return conn
    except oracledb.DatabaseError as e:
        print(f"Eroare la conectare: {e}")
        return None

#a)
def list_table_content(conn):
    """Listare și sortare conținut pentru toate tabelele."""
    cursor = conn.cursor()
    print("\n1. Selectați tabela pentru listare:")
    print("   1. Roluri")
    print("   2. Clienti")
    print("   3. Departamente")
    print("   4. Angajati")
    print("   5. Salarii")
    print("   6. Proiecte")
    table_option = input("Alege o opțiune: ")

    #alegem optiunile
    table_mapping = {
        "1": "Roluri",
        "2": "Clienti",
        "3": "Departamente",
        "4": "Angajati",
        "5": "Salarii",
        "6": "Proiecte"
    }
    table_name = table_mapping.get(table_option)
    if not table_name:
        print("Opțiune invalidă!")
        return

    sort_column = input(f"Introduceți coloana pentru sortare în tabela {table_name}: ")
    try:
        query = f"SELECT * FROM {table_name} ORDER BY {sort_column}"
        cursor.execute(query)
        rows = cursor.fetchall()
        print(f"\nConținutul tabelei {table_name}:")
        for row in rows:
            print(row)
    except oracledb.DatabaseError as e:
        print(f"Eroare la interogare: {e}")

#b)
def update_table_content(conn):
    """Actualizare sau ștergere conținut."""
    cursor = conn.cursor()
    print("\n2. Selectați tabela pentru actualizare/ștergere:")
    print("   1. Roluri")
    print("   2. Clienti")
    print("   3. Departamente")
    print("   4. Angajati")
    print("   5. Salarii")
    print("   6. Proiecte")
    table_option = input("Alege o opțiune: ")

    #alegem tabelele
    table_mapping = {
        "1": "Roluri",
        "2": "Clienti",
        "3": "Departamente",
        "4": "Angajati",
        "5": "Salarii",
        "6": "Proiecte"
    }
    table_name = table_mapping.get(table_option)
    if not table_name:
        print("Opțiune invalidă!")
        return

    print("\nOpțiuni:")
    print("   1. Actualizează un rând")
    print("   2. Șterge un rând")
    action = input("Alege o acțiune: ")

    if action == "1":
        column_name = input(f"Introduceți numele coloanei pe care doriți să o actualizați în tabela {table_name}: ")
        new_value = input(f"Introduceți noua valoare pentru {column_name}: ")
        condition = input(f"Introduceți condiția pentru actualizare (ex: id = 1): ")

        try:
            query = f"UPDATE {table_name} SET {column_name} = :new_value WHERE {condition}"
            cursor.execute(query, [new_value])
            conn.commit()
            print("Rând actualizat cu succes!")
        except oracledb.DatabaseError as e:
            print(f"Eroare la actualizare: {e}")
    elif action == "2":
        condition = input(f"Introduceți condiția pentru ștergere (ex: id = 1): ")

        try:
            query = f"DELETE FROM {table_name} WHERE {condition}"
            cursor.execute(query)
            conn.commit()
            print("Rând șters cu succes!")
        except oracledb.DatabaseError as e:
            print(f"Eroare la ștergere: {e}")
    else:
        print("Opțiune invalidă!")

#c)
def complex_query(conn):
    """Execută o interogare complexă."""
    cursor = conn.cursor()
    print("\nExecut interogarea complexă...")
    query = """
        SELECT a.nume AS angajat, d.nume AS departament, p.nume AS proiect
        FROM Angajati a
        JOIN Departamente d ON a.id_departament = d.id_departament
        JOIN Proiecte p ON d.id_departament = p.id_client
        WHERE a.salariu > 5000 AND p.buget > 100000
    """
    try:
        cursor.execute(query)
        rows = cursor.fetchall()
        print("Rezultatele interogării:")
        for row in rows:
            print(row)
    except oracledb.DatabaseError as e:
        print(f"Eroare la interogare: {e}")

#d)
def group_query_with_having(conn):
    """Execută o cerere cu funcții grup și clauza HAVING."""
    cursor = conn.cursor()
    print("\nExecut cererea cu funcții grup și HAVING...")
    query = """
        SELECT a.id_departament, COUNT(*) AS numar_angajati, AVG(a.salariu) AS salariu_mediu
        FROM Angajati a
        GROUP BY a.id_departament
        HAVING AVG(a.salariu) > 5000
    """
    try:
        cursor.execute(query)
        rows = cursor.fetchall()
        print("Rezultatele interogării:")
        for row in rows:
            print(f"Departament: {row[0]}, Numar Angajati: {row[1]}, Salariu Mediu: {row[2]}")
    except oracledb.DatabaseError as e:
        print(f"Eroare la interogare: {e}")

#e)
def constraint_on_delete_cascade(conn):
    """Exemplifică ON DELETE CASCADE."""
    cursor = conn.cursor()
    print("\nExemplificare ON DELETE CASCADE...")
    try:
        #sterg client si vedem cum afecteaza tabelele asociate
        client_id = input("Introduceți ID-ul unui client pentru ștergere: ")
        query = "DELETE FROM Clienti WHERE id_client = :client_id"
        cursor.execute(query, [client_id])
        conn.commit()
        print(f"Clientul cu ID-ul {client_id} a fost șters cu succes!")
    except oracledb.DatabaseError as e:
        print(f"Eroare la ștergere: {e}")

#f)
def create_and_use_views(conn):
    """Creează și utilizează vizualizări."""
    cursor = conn.cursor()

    print("\n=== Creare Vizualizări ===")
    try:
        #vizualizare simpla, compusa
        cursor.execute("CREATE OR REPLACE VIEW View_Angajati_Proiecte AS "
                       "SELECT a.id_angajat, a.nume, p.nume AS proiect "
                       "FROM Angajati a "
                       "JOIN Proiecte p ON a.id_departament = p.id_client")
        print("Vizualizarea 'View_Angajati_Proiecte' creată cu succes!")

        #vizualizare complexa
        cursor.execute("CREATE OR REPLACE VIEW View_Departamente_Statistici AS "
                       "SELECT d.nume AS departament, COUNT(a.id_angajat) AS numar_angajati, AVG(a.salariu) AS salariu_mediu "
                       "FROM Departamente d "
                       "JOIN Angajati a ON d.id_departament = a.id_departament "
                       "GROUP BY d.nume")
        print("Vizualizarea 'View_Departamente_Statistici' creată cu succes!")

        print("\n=== Interogare Vizualizări ===")
        cursor.execute("SELECT * FROM View_Angajati_Proiecte")
        rows = cursor.fetchall()
        print("\nView_Angajati_Proiecte:")
        for row in rows:
            print(row)

        cursor.execute("SELECT * FROM View_Departamente_Statistici")
        rows = cursor.fetchall()
        print("\nView_Departamente_Statistici:")
        for row in rows:
            print(row)
    except oracledb.DatabaseError as e:
        print(f"Eroare la crearea sau utilizarea vizualizărilor: {e}")

#meniu
def main_menu():
    conn = connect_to_db()
    if not conn:
        return

    while True:
        print("\n=== MENIU PRINCIPAL ===")
        print("1. Listare si sortare conținut tabele")
        print("2. Actualizare/Ștergere conținut tabele")
        print("3. Executare interogare complexa")
        print("4. Executare cerere cu functii grup și HAVING")
        print("5. Exemplificare ON DELETE CASCADE")
        print("6. Creare si utilizare vizualizari")
        print("7. Iesire")
        option = input("Alege o optiune: ")

        if option == "1":
            list_table_content(conn)
        elif option == "2":
            update_table_content(conn)
        elif option == "3":
            complex_query(conn)
        elif option == "4":
            group_query_with_having(conn)
        elif option == "5":
            constraint_on_delete_cascade(conn)
        elif option == "6":
            create_and_use_views(conn)
        elif option == "7":
            print("La revedere!")
            conn.close()
            break
        else:
            print("Optiune invalida!")


if __name__ == "__main__":
    main_menu()
