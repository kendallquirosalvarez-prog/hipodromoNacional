"""
Genera Hipodromo_Nacional.pptx — Hipódromo Nacional (Spring Boot)
13 diapositivas, sin animaciones, tema oscuro.
Requiere: pip install python-pptx
"""

from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN
from pptx.util import Inches, Pt
import copy
from lxml import etree

OUT = "Hipodromo_Nacional.pptx"

# ── Paleta ────────────────────────────────────────────────────────────────────
BG     = RGBColor(0x0d, 0x11, 0x17)   # fondo oscuro
BG2    = RGBColor(0x16, 0x1b, 0x27)   # tarjetas
BLUE   = RGBColor(0x58, 0xa6, 0xff)
GREEN  = RGBColor(0x3f, 0xb9, 0x50)
ORANGE = RGBColor(0xff, 0xa6, 0x57)
RED    = RGBColor(0xf7, 0x81, 0x66)
GOLD   = RGBColor(0xff, 0xd7, 0x00)
PURPLE = RGBColor(0xbc, 0x8c, 0xff)
WHITE  = RGBColor(0xf0, 0xf6, 0xfc)
GRAY   = RGBColor(0x8b, 0x94, 0x9e)
LIGHT  = RGBColor(0xad, 0xba, 0xc7)

W = Inches(13.33)
H = Inches(7.5)

prs = Presentation()
prs.slide_width  = W
prs.slide_height = H

BLANK = prs.slide_layouts[6]   # completamente en blanco

# ── Helpers ───────────────────────────────────────────────────────────────────

def new_slide():
    return prs.slides.add_slide(BLANK)

def bg(slide, color=BG):
    fill = slide.background.fill
    fill.solid()
    fill.fore_color.rgb = color

def box(slide, l, t, w, h, color=BG2, border=None, border_w=Pt(1)):
    sh = slide.shapes.add_shape(1, l, t, w, h)
    sh.fill.solid(); sh.fill.fore_color.rgb = color
    if border:
        sh.line.color.rgb = border
        sh.line.width = border_w
    else:
        sh.line.fill.background()
    return sh

def txt(slide, text, l, t, w, h, size=18, bold=False, color=WHITE,
        align=PP_ALIGN.LEFT, wrap=True):
    txb = slide.shapes.add_textbox(l, t, w, h)
    tf  = txb.text_frame
    tf.word_wrap = wrap
    p = tf.paragraphs[0]
    p.alignment = align
    run = p.add_run()
    run.text = text
    run.font.size   = Pt(size)
    run.font.bold   = bold
    run.font.color.rgb = color
    return txb

def accent_bar(slide, color=BLUE):
    bar = slide.shapes.add_shape(1, 0, 0, W, Pt(4))
    bar.fill.solid(); bar.fill.fore_color.rgb = color
    bar.line.fill.background()

def slide_num(slide, n, total=13):
    txt(slide, f"{n} / {total}",
        W - Inches(1.2), H - Inches(0.4), Inches(1.1), Inches(0.3),
        size=9, color=GRAY, align=PP_ALIGN.RIGHT)

def pill_row(slide, items, t, spacing=Inches(0.05)):
    """items = [(label, color), ...]"""
    x = Inches(0.5)
    for label, color in items:
        w = Inches(len(label) * 0.115 + 0.35)
        sh = slide.shapes.add_shape(5, x, t, w, Inches(0.3))   # RoundRect
        sh.fill.solid(); sh.fill.fore_color.rgb = BG2
        sh.line.color.rgb = color; sh.line.width = Pt(1)
        tf = sh.text_frame
        tf.word_wrap = False
        p = tf.paragraphs[0]; p.alignment = PP_ALIGN.CENTER
        r = p.add_run(); r.text = label
        r.font.size = Pt(10); r.font.bold = True; r.font.color.rgb = color
        x += w + spacing

def card(slide, l, t, w, h, title, body, icon="", accent=BLUE):
    box(slide, l, t, w, h, BG2)
    # borde superior de color
    bar = slide.shapes.add_shape(1, l, t, w, Pt(3))
    bar.fill.solid(); bar.fill.fore_color.rgb = accent
    bar.line.fill.background()
    cy = t + Inches(0.12)
    if icon:
        txt(slide, icon, l + Inches(0.1), cy, Inches(0.45), Inches(0.4), size=18)
        txt(slide, title, l + Inches(0.55), cy, w - Inches(0.65), Inches(0.35),
            size=11, bold=True, color=WHITE)
    else:
        txt(slide, title, l + Inches(0.12), cy, w - Inches(0.2), Inches(0.35),
            size=11, bold=True, color=WHITE)
    txt(slide, body,
        l + Inches(0.12), t + Inches(0.55),
        w - Inches(0.22), h - Inches(0.65),
        size=9.5, color=LIGHT)

def code_box(slide, l, t, w, h, lines):
    """lines = list of (text, color)"""
    sh = box(slide, l, t, w, h, RGBColor(0x01, 0x04, 0x09),
             border=RGBColor(0x30, 0x36, 0x3d))
    txb = slide.shapes.add_textbox(l + Inches(0.15), t + Inches(0.1),
                                    w - Inches(0.3), h - Inches(0.2))
    tf = txb.text_frame; tf.word_wrap = False
    first = True
    for text, color in lines:
        if first:
            p = tf.paragraphs[0]; first = False
        else:
            p = tf.add_paragraph()
        p.space_before = Pt(0); p.space_after = Pt(0)
        r = p.add_run(); r.text = text
        r.font.size = Pt(8.5)
        r.font.color.rgb = color
        r.font.name = "Courier New"

def analogy(slide, text, t):
    sh = box(slide, Inches(0.5), t, W - Inches(1), Inches(0.55),
             RGBColor(0x1a, 0x1f, 0x0d))
    sh.line.color.rgb = GREEN; sh.line.width = Pt(2)
    txt(slide, "💡  " + text,
        Inches(0.65), t + Inches(0.08), W - Inches(1.3), Inches(0.45),
        size=9.5, color=WHITE)

def section_header(slide, title, sub, n):
    accent_bar(slide)
    txt(slide, title, Inches(0.5), Inches(0.28), W - Inches(1), Inches(0.62),
        size=28, bold=True, color=WHITE)
    txt(slide, sub, Inches(0.5), Inches(0.92), W - Inches(1), Inches(0.35),
        size=11, color=GRAY)
    # divisor
    div = slide.shapes.add_shape(1, Inches(0.5), Inches(1.3),
                                  W - Inches(1), Pt(2))
    div.fill.solid(); div.fill.fore_color.rgb = BLUE
    div.line.fill.background()
    slide_num(slide, n)

# ══════════════════════════════════════════════════════════════════════════════
# 1. PORTADA
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
accent_bar(sl)

# gradiente simulado con shape semitransparente
grad = sl.shapes.add_shape(1, 0, 0, Inches(6), H)
grad.fill.solid(); grad.fill.fore_color.rgb = RGBColor(0x1c, 0x2d, 0x42)
grad.line.fill.background()
try:
    grad.fill.fore_color.theme_color  # solo intento, no crítico
except Exception:
    pass

txt(sl, "🏇", Inches(0.6), Inches(0.9), Inches(1.2), Inches(1.0), size=52)
txt(sl, "HIPÓDROMO", Inches(0.6), Inches(1.8), Inches(8), Inches(1.0),
    size=52, bold=True, color=WHITE)
txt(sl, "NACIONAL", Inches(0.6), Inches(2.65), Inches(8), Inches(0.9),
    size=52, bold=True, color=BLUE)
txt(sl, "Sistema Web de Control de Carrera de Caballos",
    Inches(0.6), Inches(3.55), Inches(9), Inches(0.45),
    size=16, color=GRAY)

pill_row(sl, [
    ("Spring Boot 3.5", BLUE),
    ("Spring Security", BLUE),
    ("Thymeleaf", GREEN),
    ("Spring Data JPA", GREEN),
    ("PostgreSQL", ORANGE),
    ("Supabase", ORANGE),
    ("Railway", GOLD),
    ("Git / GitHub", RED),
], t=Inches(4.2))

div = sl.shapes.add_shape(1, Inches(0.6), Inches(5.0), Inches(9), Pt(1))
div.fill.solid(); div.fill.fore_color.rgb = RGBColor(0x30, 0x36, 0x3d)
div.line.fill.background()
txt(sl,
    "IF-5100 Administración de Bases de Datos  ·  Universidad de Costa Rica  ·  Sede Liberia  ·  2025–2026",
    Inches(0.6), Inches(5.1), Inches(10), Inches(0.35),
    size=9, color=GRAY)
slide_num(sl, 1)

# ══════════════════════════════════════════════════════════════════════════════
# 2. ARQUITECTURA EN CAPAS
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Arquitectura del Sistema",
    "Cómo fluye una petición desde el navegador hasta PostgreSQL en Supabase", 2)

layers = [
    ("🌐  Navegador (Usuario)", BLUE,
     "Abre https://hipodromo.railway.app · HTML generado en el servidor · Sin JavaScript pesado"),
    ("🔒  Spring Security", GREEN,
     "Intercepta cada petición · Verifica sesión · Redirige a /login · Aplica reglas de rol por URL"),
    ("⚙️  Controllers (MVC)", ORANGE,
     "Recibe la petición HTTP · Llama al Repository · Agrega datos al Model · Devuelve template"),
    ("📦  Spring Data JPA", GOLD,
     "Repositorios con @Query(nativeQuery=true) · Invoca stored procedures: CALL sp_insertar_caballo(...)"),
    ("🗃️  PostgreSQL (Supabase)", RED,
     "14 tablas · Stored procedures · Triggers de auditoría · Bitácoras particionadas por trimestre"),
]
row_h = Inches(0.78)
top = Inches(1.5)
for label, color, detail in layers:
    sh = box(sl, Inches(0.5), top, W - Inches(1), row_h - Inches(0.06),
             BG2, border=color, border_w=Pt(1))
    txt(sl, label, Inches(0.65), top + Inches(0.18), Inches(3.5), Inches(0.45),
        size=11, bold=True, color=color)
    txt(sl, detail, Inches(4.3), top + Inches(0.18), W - Inches(4.9), Inches(0.45),
        size=9.5, color=LIGHT)
    if layers.index((label, color, detail)) < len(layers) - 1:
        txt(sl, "↕", Inches(6.2), top + row_h - Inches(0.04), Inches(0.4),
            Inches(0.25), size=11, color=GRAY, align=PP_ALIGN.CENTER)
    top += row_h

# ══════════════════════════════════════════════════════════════════════════════
# 3. SPRING BOOT
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Spring Boot — El Motor del Sistema",
    "Framework Java que convierte código en una aplicación web lista para producción", 3)

card(sl, Inches(0.5), Inches(1.55), Inches(5.5), Inches(1.35),
    "Sin configuración manual",
    "Un solo application.properties configura todo: base de datos, puerto, seguridad.\n"
    "No hace falta instalar un servidor web — Spring Boot incluye Tomcat embebido.", "🚀", BLUE)

card(sl, Inches(0.5), Inches(2.98), Inches(5.5), Inches(2.1),
    "Ciclo petición → respuesta",
    "1. Llega GET /caballos\n"
    "2. Security verifica rol\n"
    "3. CaballoController llama al repository\n"
    "4. JPA ejecuta la consulta en Supabase\n"
    "5. Thymeleaf renderiza caballos/index.html\n"
    "6. HTML final al navegador", "🔄", GREEN)

code_box(sl, Inches(6.2), Inches(1.55), Inches(6.65), Inches(3.6), [
    ("# application.properties", GRAY),
    ("server.port=${PORT:8080}", LIGHT),
    ("spring.datasource.url=${DB_URL}", LIGHT),
    ("spring.datasource.username=${DB_USERNAME}", LIGHT),
    ("spring.jpa.hibernate.ddl-auto=none", LIGHT),
    ("", LIGHT),
    ("// CaballoController.java", GRAY),
    ("@Controller", GREEN),
    ("@RequestMapping(\"/caballos\")", GREEN),
    ("public class CaballoController {", LIGHT),
    ("  @Autowired", GREEN),
    ("  private CaballoRepository repo;", LIGHT),
    ("", LIGHT),
    ("  @GetMapping", GREEN),
    ("  public String listar(Model model) {", LIGHT),
    ("    model.addAttribute(\"caballos\",", LIGHT),
    ("        repo.findAll());", LIGHT),
    ("    return \"caballos/index\";", ORANGE),
    ("  }", LIGHT),
    ("}", LIGHT),
])

analogy(sl, "Spring Boot es como una cocina industrial lista para usar — los electrodomésticos "
        "(Tomcat, JPA, Security) ya están instalados. Solo traés los ingredientes (tu código).",
        Inches(5.25))

# ══════════════════════════════════════════════════════════════════════════════
# 4. GIT Y GITHUB
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Git y GitHub — Historial del Proyecto",
    "Cada cambio queda registrado · Trabajo en equipo sin pisarse el código", 4)

card(sl, Inches(0.5), Inches(1.55), Inches(5.5), Inches(1.6),
    "¿Qué hace Git?",
    "Guarda instantáneas (commits) en cada punto importante.\n"
    "Si algo se rompe, podés volver a cualquier commit anterior con git checkout.\n"
    "Cada commit registra: qué cambió, quién lo hizo y cuándo.", "📁", ORANGE)

card(sl, Inches(0.5), Inches(3.25), Inches(5.5), Inches(1.5),
    "GitHub = Git en la nube",
    "El repo local se sincroniza con GitHub.\n"
    "Railway lee de GitHub — cada git push dispara un nuevo despliegue automático en producción.", "☁️", BLUE)

code_box(sl, Inches(6.2), Inches(1.55), Inches(6.65), Inches(3.3), [
    ("# Flujo de trabajo del proyecto", GRAY),
    ("", LIGHT),
    ("# Ver qué cambió", GRAY),
    ("git status", LIGHT),
    ("git diff", LIGHT),
    ("", LIGHT),
    ("# Preparar los cambios", GRAY),
    ("git add src/main/java/...", LIGHT),
    ("", LIGHT),
    ("# Guardar el commit", GRAY),
    ("git commit -m \"feat: módulo Suministros\"", ORANGE),
    ("", LIGHT),
    ("# Subir a GitHub (dispara Railway)", GRAY),
    ("git push origin main", LIGHT),
    ("", LIGHT),
    ("# Historial del proyecto", GRAY),
    ("74488d7 Agregar 5 módulos + presentación", GREEN),
    ("6627052 Agregar página ER y procedimientos", GREEN),
    ("2c7c076 Agregar Spring Security con roles", GREEN),
    ("e7c051d Proyecto final IF-5100", GREEN),
])

analogy(sl, "Git es como el historial de Google Docs — podés ver cada versión anterior y restaurarla. "
        "GitHub es el Google Drive donde se guarda todo en la nube.", Inches(5.05))

# ══════════════════════════════════════════════════════════════════════════════
# 5. SUPABASE + RAILWAY
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Supabase y Railway — La Nube",
    "Base de datos y servidor web, ambos gratuitos y siempre disponibles", 5)

card(sl, Inches(0.5), Inches(1.55), Inches(6.1), Inches(3.5),
    "Supabase — PostgreSQL en la nube",
    "Provee un servidor PostgreSQL completamente administrado.\n\n"
    "El proyecto se conecta con la URL de Supabase — funciona igual\n"
    "en la laptop y en producción.\n\n"
    "URL de conexión:\n"
    "jdbc:postgresql://aws-1...supabase.com:6543/postgres\n\n"
    "Schema Visualizer, Dashboard SQL y backups automáticos incluidos.", "🗄️", GREEN)

card(sl, Inches(6.9), Inches(1.55), Inches(5.95), Inches(3.5),
    "Railway — Servidor web en la nube",
    "Ejecuta el JAR de Spring Boot en un contenedor Docker.\n\n"
    "Despliegue automático:\n"
    "git push → Railway detecta el cambio →\n"
    "compila el JAR → reinicia → nuevo código activo en ~2 min.\n\n"
    "Las variables de entorno (DB_URL, DB_PASSWORD, PORT)\n"
    "se configuran en Railway — nunca en el código fuente.", "🚄", GOLD)

analogy(sl,
    "Supabase = contratar un DBA 24/7 que administra tu servidor de base de datos.  "
    "Railway = el local donde ponés tu negocio — vos ponés la app, ellos manejan el resto.",
    Inches(5.25))

# ══════════════════════════════════════════════════════════════════════════════
# 6. SPRING SECURITY
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Spring Security — Acceso Controlado",
    "Cada rol solo ve lo que necesita · Contraseñas encriptadas con BCrypt", 6)

roles = [
    ("👑", "ADMIN",      "#c62428", "Acceso total a todos los módulos"),
    ("💉", "VETERINARIO", "#3fb950", "Historial vet. y alertas"),
    ("📋", "OPERADOR",   "#ffa657", "Eventos, facturas y resultados"),
    ("🌾", "ENCARGADO",  "#58a6ff", "Establos, suministros y alimentación"),
]
col_w = Inches(2.7)
for i, (icon, role, hex_c, desc) in enumerate(roles):
    cc = RGBColor(int(hex_c[1:3],16), int(hex_c[3:5],16), int(hex_c[5:7],16))
    lx = Inches(0.5) + i * (col_w + Inches(0.15))
    sh = box(sl, lx, Inches(1.55), col_w, Inches(1.8), BG2)
    bar2 = sl.shapes.add_shape(1, lx, Inches(1.55), col_w, Pt(3))
    bar2.fill.solid(); bar2.fill.fore_color.rgb = cc; bar2.line.fill.background()
    txt(sl, icon, lx + Inches(0.1), Inches(1.7), Inches(0.5), Inches(0.5), size=22)
    txt(sl, role, lx + Inches(0.1), Inches(2.2), col_w - Inches(0.2), Inches(0.35),
        size=12, bold=True, color=WHITE)
    txt(sl, desc, lx + Inches(0.1), Inches(2.58), col_w - Inches(0.2), Inches(0.55),
        size=9, color=LIGHT)

code_box(sl, Inches(0.5), Inches(3.55), Inches(12.35), Inches(1.65), [
    ("// SecurityConfig — reglas de acceso por URL y rol", GRAY),
    ("http.authorizeHttpRequests(auth -> auth", LIGHT),
    ("  .requestMatchers(\"/historial/**\", \"/alertas/**\").hasAnyRole(\"ADMIN\", \"VETERINARIO\")", LIGHT),
    ("  .requestMatchers(\"/suministros/**\", \"/alimentacion/**\").hasAnyRole(\"ADMIN\", \"ENCARGADO\")", LIGHT),
    ("  .requestMatchers(\"/facturas/**\", \"/resultados/**\").hasAnyRole(\"ADMIN\", \"OPERADOR\")", LIGHT),
    ("  .anyRequest().authenticated()  // cualquier otra ruta requiere estar autenticado", GRAY),
    (");", LIGHT),
])

analogy(sl, "Los usuarios y contraseñas se guardan en la tabla usuarios de Supabase. "
        "Spring Security los lee vía UsuarioDetailsService — no hay lista hardcodeada en el código.",
        Inches(5.4))

# ══════════════════════════════════════════════════════════════════════════════
# 7. THYMELEAF
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Thymeleaf — Las Vistas",
    "HTML procesado en el servidor con datos reales antes de llegar al navegador", 7)

card(sl, Inches(0.5), Inches(1.55), Inches(5.5), Inches(1.55),
    "Server-Side Rendering",
    "El servidor combina la plantilla HTML con los datos de la BD y envía HTML completo.\n"
    "No hay API REST, no hay React, no hay JavaScript para cargar datos.\n"
    "Lo que el usuario ve ya contiene los registros reales.", "🔄", BLUE)

card(sl, Inches(0.5), Inches(3.2), Inches(5.5), Inches(1.55),
    "th:sec — Integración con Security",
    'sec:authorize="hasRole(\'ADMIN\')" oculta elementos del HTML según el rol activo.\n'
    'El botón "Eliminar" solo aparece para ADMIN, aunque el usuario manipule la URL.', "🔐", GREEN)

code_box(sl, Inches(6.2), Inches(1.55), Inches(6.65), Inches(3.2), [
    ("<!-- caballos/index.html — tabla dinámica -->", GRAY),
    ("<tr th:each=\"c : ${caballos}\">", LIGHT),
    ("  <td th:text=\"${c.nombre}\"></td>", LIGHT),
    ("  <td>", LIGHT),
    ("    <span", LIGHT),
    ("      th:class=\"${c.estadoSalud == 'Óptimo'}", ORANGE),
    ("               ? 'badge badge-green'", GREEN),
    ("               : 'badge badge-red'\"", RED),
    ("      th:text=\"${c.estadoSalud}\">", LIGHT),
    ("    </span>", LIGHT),
    ("  </td>", LIGHT),
    ("  <!-- Solo ADMIN ve el botón eliminar -->", GRAY),
    ("  <td sec:authorize=\"hasRole('ADMIN')\">", GREEN),
    ("    <a th:href=\"@{/caballos/eliminar/{id}", LIGHT),
    ("            (id=${c.idCaballo})}\"", LIGHT),
    ("       class=\"btn-delete\">Eliminar</a>", LIGHT),
    ("  </td>", LIGHT),
    ("</tr>", LIGHT),
])

analogy(sl, "Thymeleaf es como una plantilla de Word con combinación de correspondencia — "
        "el documento ya está hecho, solo se llenan los datos antes de imprimir.",
        Inches(4.95))

# ══════════════════════════════════════════════════════════════════════════════
# 8. BASE DE DATOS
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Base de Datos PostgreSQL",
    "14 tablas normalizadas · Toda la lógica de negocio vive en stored procedures", 8)

# Lista de tablas
tablas = ["Propietarios","Establos","Caballos","Eventos",
          "Inscripciones","Resultados","Hist.Veterinario","Alertas Vet.",
          "Suministros","Alimentacion","Facturas","Transacciones",
          "Pais / Provincia","Canton / Barrio"]
box_t = box(sl, Inches(0.5), Inches(1.55), Inches(5.5), Inches(3.3), BG2)
bar3 = sl.shapes.add_shape(1, Inches(0.5), Inches(1.55), Inches(5.5), Pt(3))
bar3.fill.solid(); bar3.fill.fore_color.rgb = BLUE; bar3.line.fill.background()
txt(sl, "📊 14 Tablas del sistema",
    Inches(0.62), Inches(1.68), Inches(5.2), Inches(0.35),
    size=11, bold=True, color=WHITE)
for i, t_name in enumerate(tablas):
    col = i % 2; row = i // 2
    txt(sl, "• " + t_name,
        Inches(0.65 + col * 2.65), Inches(2.12 + row * 0.38),
        Inches(2.5), Inches(0.35),
        size=9.5, color=LIGHT)

card(sl, Inches(0.5), Inches(4.97), Inches(5.5), Inches(1.3),
    "Stored Procedures con prefijo sp_",
    "Spring Data JPA llama con @Query(nativeQuery=true)\n"
    "CALL sp_insertar_caballo(:p_id, :p_nombre, ...)\n"
    "Si cambia la regla, solo se actualiza el procedure — sin tocar Java.", "⚙️", ORANGE)

code_box(sl, Inches(6.2), Inches(1.55), Inches(6.65), Inches(4.75), [
    ("-- sp_insertar_alimentacion", GRAY),
    ("-- descuenta stock al registrar ración", GRAY),
    ("CREATE OR REPLACE PROCEDURE", RED),
    ("  sp_insertar_alimentacion(", LIGHT),
    ("    p_id_caballo    VARCHAR,", LIGHT),
    ("    p_id_suministro VARCHAR,", LIGHT),
    ("    p_tipo_alimento VARCHAR,", LIGHT),
    ("    p_cantidad      DECIMAL,", LIGHT),
    ("    p_fecha         DATE", LIGHT),
    ("  )", LIGHT),
    ("LANGUAGE plpgsql AS $$", LIGHT),
    ("BEGIN", RED),
    ("  INSERT INTO alimentacion", LIGHT),
    ("    (id_caballo, id_suministro,", LIGHT),
    ("     tipo_alimento, cantidad, fecha)", LIGHT),
    ("  VALUES", LIGHT),
    ("    (p_id_caballo, p_id_suministro,", LIGHT),
    ("     p_tipo_alimento, p_cantidad, p_fecha);", LIGHT),
    ("", LIGHT),
    ("  -- Descuenta del inventario", GRAY),
    ("  UPDATE suministro", LIGHT),
    ("     SET cantidad_disponible =", LIGHT),
    ("         cantidad_disponible - p_cantidad", LIGHT),
    ("   WHERE id_suministro = p_id_suministro;", LIGHT),
    ("END; $$;", LIGHT),
])

# ══════════════════════════════════════════════════════════════════════════════
# 9. AUTOMATIZACIÓN
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Automatización — Triggers y Bitácoras",
    "La base de datos trabaja sola — auditoría completa sin intervención del programador", 9)

autos = [
    ("📋", "Bitácoras Particionadas", PURPLE,
     "6 tablas × 4 trimestres\nCada partición filtra por rango de fechas — consultar Q2 no toca registros del Q1"),
    ("🔍", "18 Triggers de Auditoría", BLUE,
     "3 por tabla auditada:\nAFTER INSERT · UPDATE · DELETE\nCaptura CURRENT_USER, TG_OP, NOW() en cada operación"),
    ("🔔", "Alerta Vencimiento", GREEN,
     "Trigger AFTER UPDATE en Caballos\nSi la certificación vence en menos de 30 días, inserta en alerta_veterinaria"),
    ("💰", "Descuento Frecuentes", ORANGE,
     "Trigger BEFORE INSERT en Facturas\n>₡500k facturados en 6 meses → aplica 10% descuento automático"),
]
cw = (W - Inches(1.2)) / 4 - Inches(0.08)
for i, (icon, title, color, body) in enumerate(autos):
    lx = Inches(0.5) + i * (cw + Inches(0.1))
    card(sl, lx, Inches(1.55), cw, Inches(3.15), title, body, icon, color)

analogy(sl, "Los triggers corren en PostgreSQL, NO en Spring Boot. El controller solo llama "
        "sp_insertar_alimentacion() — la auditoría, descuento y alertas ocurren automáticamente en la BD.",
        Inches(4.9))

# ══════════════════════════════════════════════════════════════════════════════
# 10. FACTURACIÓN
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Facturación — Ley 9635 Costa Rica",
    "IVA 13% calculado automáticamente · Historial de pagos por transacción", 10)

steps = [
    ("₡150,000", "Precio inscripción", BLUE, "+"),
    ("5%", "Comisión admin.", ORANGE, "−"),
    ("10%*", "Desc. frecuente", GREEN, "×"),
    ("13%", "IVA Ley 9635", RED, "="),
    ("TOTAL", "Factura final", GOLD, ""),
]
sw = Inches(1.85)
sx = Inches(0.5)
for i, (val, lbl, color, op) in enumerate(steps):
    sh = box(sl, sx, Inches(1.55), sw, Inches(1.15), BG2,
             border=color if color == GOLD else None)
    txt(sl, val, sx, Inches(1.65), sw, Inches(0.55),
        size=20, bold=True, color=color, align=PP_ALIGN.CENTER)
    txt(sl, lbl, sx, Inches(2.18), sw, Inches(0.4),
        size=9, color=GRAY, align=PP_ALIGN.CENTER)
    sx += sw
    if op:
        txt(sl, op, sx, Inches(1.82), Inches(0.45), Inches(0.45),
            size=18, color=GRAY, align=PP_ALIGN.CENTER)
        sx += Inches(0.45)

txt(sl, "* Solo aplica si el propietario supera ₡500,000 en los últimos 6 meses",
    Inches(0.5), Inches(2.85), W - Inches(1), Inches(0.3),
    size=9, color=GRAY)

code_box(sl, Inches(0.5), Inches(3.2), W - Inches(1), Inches(2.55), [
    ("-- Vista resumen de facturas con cálculo IVA visible", GRAY),
    ("SELECT (p.nombre || ' ' || p.apellidos) AS propietario,", LIGHT),
    ("       e.nombre AS evento, f.subtotal, f.descuento,", LIGHT),
    ("       (f.subtotal - f.descuento) AS base_imponible,", LIGHT),
    ("       f.impuestos AS iva_13pct, f.total,", LIGHT),
    ("       CASE WHEN f.descuento > 0 THEN 'Sí (cliente frecuente)' ELSE 'No' END AS descuento_aplicado,", LIGHT),
    ("       f.estado_pago", LIGHT),
    ("FROM factura f", LIGHT),
    ("JOIN propietario p ON p.id_propietario = f.id_propietario", LIGHT),
    ("JOIN evento e ON e.id_evento = f.id_evento", LIGHT),
    ("ORDER BY f.fecha_emision DESC;", LIGHT),
])

# ══════════════════════════════════════════════════════════════════════════════
# 11. 12 MÓDULOS
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "12 Módulos del Sistema",
    "Cada módulo: formulario de registro, tabla con lista, editar y eliminar", 11)

modules = [
    ("👤","Propietarios","CRUD completo",BLUE),
    ("🏠","Establos","Estado y capacidad",GREEN),
    ("🐎","Caballos","Salud y propietario",ORANGE),
    ("🏁","Eventos","Carreras y premios",BLUE),
    ("📋","Inscripciones","Caballo + Evento",GREEN),
    ("🏆","Resultados","Posiciones y premios",GOLD),
    ("💰","Facturas","IVA + descuentos",ORANGE),
    ("💳","Transacciones","Pagos de facturas",RED),
    ("🩺","Historial Vet.","Diagnósticos",PURPLE),
    ("🔔","Alertas Vet.","Vencimientos",BLUE),
    ("📦","Suministros","Inventario",GREEN),
    ("🌾","Alimentación","Raciones diarias",ORANGE),
]
cols, rows = 4, 3
mw = (W - Inches(1.2)) / cols - Inches(0.08)
mh = (H - Inches(2.1)) / rows - Inches(0.1)
for i, (icon, name, desc, color) in enumerate(modules):
    col = i % cols; row = i // cols
    lx = Inches(0.5) + col * (mw + Inches(0.1))
    lt = Inches(1.6) + row * (mh + Inches(0.1))
    sh = box(sl, lx, lt, mw, mh, BG2)
    b2 = sl.shapes.add_shape(1, lx, lt, mw, Pt(2))
    b2.fill.solid(); b2.fill.fore_color.rgb = color; b2.line.fill.background()
    txt(sl, icon, lx + Inches(0.12), lt + Inches(0.12),
        Inches(0.45), Inches(0.45), size=18)
    txt(sl, name, lx + Inches(0.12), lt + Inches(0.55),
        mw - Inches(0.2), Inches(0.35), size=11, bold=True, color=WHITE)
    txt(sl, desc, lx + Inches(0.12), lt + Inches(0.88),
        mw - Inches(0.2), Inches(0.3), size=9, color=GRAY)

# ══════════════════════════════════════════════════════════════════════════════
# 12. PROCESO DE CONSTRUCCIÓN
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
section_header(sl,
    "Proceso de Construcción",
    "5 fases ordenadas — cada una depende de la anterior", 12)

fases = [
    ("📐", "1. Diseño BD", BLUE,
     "Diagrama ER\nNormalización 3FN\nDDL: 14 tablas\nConstraints FK"),
    ("⚙️", "2. Lógica PostgreSQL", GREEN,
     "Stored procedures\nBitácoras particionadas\n18 triggers auditoría\nRoles y permisos"),
    ("🌱", "3. Spring Boot", ORANGE,
     "Proyecto Maven\nModelos JPA\nRepositorios\nControllers MVC"),
    ("🔒", "4. Spring Security", RED,
     "Login personalizado\n4 roles definidos\nReglas por URL\nBCrypt en contraseñas"),
    ("🚀", "5. Git + Railway", GOLD,
     "GitHub repo público\nRailway conectado\nSupabase cloud\nCI/CD automático"),
]
fw = (W - Inches(1.2)) / 5 - Inches(0.06)
for i, (icon, title, color, body) in enumerate(fases):
    lx = Inches(0.5) + i * (fw + Inches(0.08))
    sh = box(sl, lx, Inches(1.55), fw, Inches(3.3), BG2)
    b2 = sl.shapes.add_shape(1, lx, Inches(1.55), fw, Pt(3))
    b2.fill.solid(); b2.fill.fore_color.rgb = color; b2.line.fill.background()
    txt(sl, icon, lx + fw/2 - Inches(0.25), Inches(1.7),
        Inches(0.5), Inches(0.5), size=22, align=PP_ALIGN.CENTER)
    txt(sl, title, lx + Inches(0.08), Inches(2.2), fw - Inches(0.15),
        Inches(0.4), size=10, bold=True, color=color)
    txt(sl, body, lx + Inches(0.08), Inches(2.65), fw - Inches(0.15),
        Inches(1.9), size=9, color=LIGHT)
    if i < len(fases) - 1:
        txt(sl, "→", lx + fw, Inches(2.85), Inches(0.2), Inches(0.4),
            size=14, color=GRAY, align=PP_ALIGN.CENTER)

analogy(sl, "Regla de oro: no se escribe código Java sin que el stored procedure ya exista y funcione "
        "en Supabase. El servidor de aplicaciones es el cliente de la BD, no al revés.",
        Inches(5.0))

# ══════════════════════════════════════════════════════════════════════════════
# 13. CIERRE
# ══════════════════════════════════════════════════════════════════════════════
sl = new_slide(); bg(sl)
accent_bar(sl)
txt(sl, "Resumen del Proyecto",
    Inches(0.5), Inches(0.28), W - Inches(1), Inches(0.62),
    size=28, bold=True, color=WHITE)
div2 = sl.shapes.add_shape(1, Inches(0.5), Inches(0.92), W - Inches(4.5), Pt(2))
div2.fill.solid(); div2.fill.fore_color.rgb = BLUE; div2.line.fill.background()

logros = [
    ("🗄️", "14 tablas normalizadas hasta 3FN con constraints, FK y CHECK en PostgreSQL"),
    ("⚙️", "Stored procedures para todo CRUD + lógica de negocio (IVA, descuentos, premios)"),
    ("📋", "6 bitácoras particionadas por trimestre · 18 triggers de auditoría automática"),
    ("🌱", "Spring Boot 3.5 con 12 módulos CRUD usando Thymeleaf + Spring Data JPA"),
    ("🔒", "Spring Security con 4 roles, login propio y contraseñas BCrypt en Supabase"),
    ("🚀", "Despliegue continuo: git push → Railway compila y publica en producción"),
    ("💳", "Facturación con IVA 13% según Ley 9635 CR · Historial de transacciones"),
]
for i, (icon, text) in enumerate(logros):
    lt = Inches(1.1) + i * Inches(0.77)
    sh = box(sl, Inches(0.5), lt, Inches(9.4), Inches(0.65), BG2)
    sl.shapes.add_shape(1, Inches(0.5), lt, Pt(3), Inches(0.65)).fill.solid()
    sl.shapes[-1].fill.fore_color.rgb = BLUE
    sl.shapes[-1].line.fill.background()
    txt(sl, icon, Inches(0.65), lt + Inches(0.12), Inches(0.45), Inches(0.42), size=16)
    txt(sl, text, Inches(1.15), lt + Inches(0.14), Inches(8.65), Inches(0.42),
        size=10.5, color=WHITE)

# QR
try:
    import qrcode, io
    qr = qrcode.QRCode(version=6, box_size=8, border=3,
                       error_correction=qrcode.constants.ERROR_CORRECT_M)
    qr.add_data("https://htmlpreview.github.io/?https://github.com/kendallquirosalvarez-prog/hipodromoNacional/blob/main/src/main/resources/static/er-diagram-completo.html")
    qr.make(fit=True)
    qr_img = qr.make_image(fill_color="#58A6FF", back_color="#0D1117")
    buf = io.BytesIO(); qr_img.save(buf, format='PNG'); buf.seek(0)
    sl.shapes.add_picture(buf, Inches(10.2), Inches(1.1), Inches(2.65), Inches(2.65))
except Exception:
    pass

box(sl, Inches(10.2), Inches(4.0), Inches(2.65), Inches(0.75), BG2)
txt(sl, "UCR Sede Liberia · 2025–2026",
    Inches(10.2), Inches(4.0), Inches(2.65), Inches(0.35),
    size=9, color=GRAY, align=PP_ALIGN.CENTER)
txt(sl, "IF-5100 Bases de Datos",
    Inches(10.2), Inches(4.35), Inches(2.65), Inches(0.35),
    size=10, bold=True, color=WHITE, align=PP_ALIGN.CENTER)
slide_num(sl, 13)

# ── Guardar ───────────────────────────────────────────────────────────────────
prs.save(OUT)
size_kb = round(__import__('os').path.getsize(OUT) / 1024, 1)
print(f"PowerPoint generado: {OUT}  ({size_kb} KB)")
print("Abrir con Microsoft PowerPoint o LibreOffice Impress.")
