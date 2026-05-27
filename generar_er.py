#!/usr/bin/env python3
"""Genera er-diagram.svg — Diagrama ER completo del Hipódromo Nacional (18 tablas)."""
import os

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "src", "main", "resources", "static", "er-diagram.svg")

# ── Paleta ───────────────────────────────────────────────────────────────────
BG        = "#0d1117"
HDR_FILL  = "#1c2d42"
BODY_FILL = "#161b27"
ROW_ALT   = "#191e2d"
BORDER    = "#30363d"
PK_COLOR  = "#ffd700"
FK_COLOR  = "#79c0ff"
COL_COLOR = "#e6edf3"
TYPE_CLR  = "#8b949e"
REL_CLR   = "#2d4a6b"
REL_FADE  = "#1e3248"

HEADER_H = 34
ROW_H    = 22
PAD_B    = 6

def th(t):
    return HEADER_H + len(t["cols"]) * ROW_H + PAD_B

# ── Definición de tablas ─────────────────────────────────────────────────────
TABLES = {
    # ── Geografía ────────────────────────────────────────────────────────────
    "pais": dict(x=15, y=25, w=195, cols=[
        ("PK","id_pais","SERIAL"),
        ("",  "nombre_pais","VARCHAR(100)"),
    ]),
    "provincia": dict(x=240, y=25, w=225, cols=[
        ("PK","id_provincia","SERIAL"),
        ("",  "nombre_provincia","VARCHAR(100)"),
        ("FK","id_pais","INT"),
    ]),
    "canton": dict(x=495, y=25, w=210, cols=[
        ("PK","id_canton","SERIAL"),
        ("",  "nombre_canton","VARCHAR(100)"),
        ("FK","id_provincia","INT"),
    ]),
    "distrito": dict(x=735, y=25, w=215, cols=[
        ("PK","id_distrito","SERIAL"),
        ("",  "nombre_distrito","VARCHAR(100)"),
        ("FK","id_canton","INT"),
    ]),
    "barrio": dict(x=980, y=25, w=210, cols=[
        ("PK","id_barrio","SERIAL"),
        ("",  "nombre_barrio","VARCHAR(100)"),
        ("FK","id_distrito","INT"),
    ]),
    # ── Entidades principales ─────────────────────────────────────────────────
    "propietario": dict(x=15, y=205, w=255, cols=[
        ("PK","id_propietario","VARCHAR(20)"),
        ("",  "nombre","VARCHAR(100)"),
        ("",  "apellidos","VARCHAR(100)"),
        ("FK","id_barrio","INT"),
        ("",  "desc_prox_factura","BOOLEAN"),
    ]),
    "establo": dict(x=15, y=470, w=240, cols=[
        ("PK","id_establo","VARCHAR(20)"),
        ("",  "capacidad","INT"),
        ("",  "estado","VARCHAR(20)"),
        ("FK","id_barrio","INT"),
    ]),
    "caballo": dict(x=325, y=200, w=265, cols=[
        ("PK","id_caballo","VARCHAR(20)"),
        ("",  "nombre","VARCHAR(100)"),
        ("",  "fecha_nacimiento","DATE"),
        ("",  "sexo","VARCHAR(10)"),
        ("",  "raza","VARCHAR(50)"),
        ("",  "peso","DECIMAL"),
        ("",  "estado_salud","VARCHAR(20)"),
        ("FK","id_propietario","VARCHAR(20)"),
        ("FK","id_establo","VARCHAR(20)"),
    ]),
    # ── Eventos e inscripciones ───────────────────────────────────────────────
    "evento": dict(x=940, y=130, w=255, cols=[
        ("PK","id_evento","VARCHAR(20)"),
        ("",  "nombre","VARCHAR(200)"),
        ("",  "fecha","TIMESTAMP"),
        ("",  "tipo_carrera","VARCHAR(50)"),
        ("",  "distancia","DECIMAL"),
        ("",  "premio_total","DECIMAL"),
        ("",  "estado","VARCHAR(20)"),
    ]),
    "inscripcion": dict(x=645, y=160, w=245, cols=[
        ("PK","id_inscripcion","VARCHAR(20)"),
        ("FK","id_evento","VARCHAR(20)"),
        ("FK","id_caballo","VARCHAR(20)"),
        ("",  "fecha_inscripcion","DATE"),
        ("",  "estado","VARCHAR(20)"),
        ("",  "posicion_final","INT"),
    ]),
    "resultado_carrera": dict(x=960, y=450, w=255, cols=[
        ("PK","id_resultado","BIGSERIAL"),
        ("FK","id_evento","VARCHAR(20)"),
        ("FK","id_caballo","VARCHAR(20)"),
        ("",  "posicion","INT"),
        ("",  "tiempo","VARCHAR(20)"),
        ("",  "premio_ganado","DECIMAL"),
    ]),
    # ── Veterinaria ────────────────────────────────────────────────────────────
    "historial_veterinario": dict(x=640, y=440, w=278, cols=[
        ("PK","id_registro","VARCHAR(20)"),
        ("FK","id_caballo","VARCHAR(20)"),
        ("",  "diagnostico","TEXT"),
        ("",  "tratamiento","TEXT"),
        ("",  "fecha_revision","DATE"),
        ("",  "fecha_venc_cert","DATE"),
        ("",  "veterinario","VARCHAR(100)"),
    ]),
    "alerta_veterinaria": dict(x=325, y=570, w=255, cols=[
        ("PK","id_alerta","BIGSERIAL"),
        ("FK","id_caballo","VARCHAR(20)"),
        ("FK","id_propietario","VARCHAR(20)"),
        ("",  "mensaje","TEXT"),
        ("",  "leida","BOOLEAN"),
        ("",  "fecha_alerta","DATE"),
    ]),
    # ── Suministros y alimentación ─────────────────────────────────────────────
    "suministro": dict(x=1260, y=315, w=250, cols=[
        ("PK","id_suministro","VARCHAR(20)"),
        ("",  "tipo","VARCHAR(50)"),
        ("",  "proveedor","VARCHAR(200)"),
        ("",  "cantidad_disponible","DECIMAL"),
        ("",  "precio_unitario","DECIMAL"),
    ]),
    "alimentacion": dict(x=1260, y=555, w=245, cols=[
        ("PK","id_alimentacion","BIGSERIAL"),
        ("FK","id_caballo","VARCHAR(20)"),
        ("FK","id_suministro","VARCHAR(20)"),
        ("",  "tipo_alimento","VARCHAR(50)"),
        ("",  "cantidad","DECIMAL"),
        ("",  "fecha","DATE"),
    ]),
    # ── Facturación ─────────────────────────────────────────────────────────────
    "factura": dict(x=325, y=840, w=255, cols=[
        ("PK","id_factura","VARCHAR(20)"),
        ("FK","id_propietario","VARCHAR(20)"),
        ("FK","id_evento","VARCHAR(20)"),
        ("",  "subtotal","DECIMAL"),
        ("",  "descuento","DECIMAL"),
        ("",  "impuestos","DECIMAL"),
        ("",  "total","DECIMAL"),
        ("",  "estado_pago","VARCHAR(20)"),
        ("",  "fecha_emision","TIMESTAMP"),
    ]),
    "historial_transaccion": dict(x=645, y=860, w=250, cols=[
        ("PK","id_transaccion","BIGSERIAL"),
        ("FK","id_factura","VARCHAR(20)"),
        ("",  "monto","DECIMAL"),
        ("",  "metodo_pago","VARCHAR(30)"),
        ("",  "fecha_pago","DATE"),
    ]),
    # ── Seguridad ───────────────────────────────────────────────────────────────
    "usuarios": dict(x=1260, y=130, w=225, cols=[
        ("PK","username","VARCHAR(50)"),
        ("",  "password","VARCHAR(255)"),
        ("",  "nombre","VARCHAR(100)"),
        ("",  "rol","VARCHAR(20)"),
        ("",  "activo","BOOLEAN"),
    ]),
}

# ── Relaciones (hijo → padre) ─────────────────────────────────────────────────
RELATIONS = [
    ("provincia","pais"),
    ("canton","provincia"),
    ("distrito","canton"),
    ("barrio","distrito"),
    ("propietario","barrio"),
    ("establo","barrio"),
    ("caballo","propietario"),
    ("caballo","establo"),
    ("inscripcion","caballo"),
    ("inscripcion","evento"),
    ("historial_veterinario","caballo"),
    ("resultado_carrera","caballo"),
    ("resultado_carrera","evento"),
    ("alerta_veterinaria","caballo"),
    ("alerta_veterinaria","propietario"),
    ("factura","propietario"),
    ("factura","evento"),
    ("alimentacion","caballo"),
    ("alimentacion","suministro"),
    ("historial_transaccion","factura"),
]

# ── SVG helpers ────────────────────────────────────────────────────────────────
def draw_table(name, t):
    x, y, w = t["x"], t["y"], t["w"]
    h = th(t)
    p = []

    # drop shadow
    p.append(f'<rect x="{x+3}" y="{y+3}" width="{w}" height="{h}" rx="7" fill="rgba(0,0,0,0.55)"/>')
    # body
    p.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="7" '
             f'fill="{BODY_FILL}" stroke="{BORDER}" stroke-width="1.5"/>')
    # header bg
    p.append(f'<rect x="{x}" y="{y}" width="{w}" height="{HEADER_H}" rx="7" fill="{HDR_FILL}"/>')
    p.append(f'<rect x="{x}" y="{y+HEADER_H-8}" width="{w}" height="9" fill="{HDR_FILL}"/>')
    # header text
    p.append(f'<text x="{x + w//2}" y="{y+22}" text-anchor="middle" '
             f'font-family="JetBrains Mono,monospace" font-size="13" font-weight="700" '
             f'fill="{PK_COLOR}">{name}</text>')
    # divider
    p.append(f'<line x1="{x+1}" y1="{y+HEADER_H}" x2="{x+w-1}" y2="{y+HEADER_H}" '
             f'stroke="{BORDER}" stroke-width="1"/>')

    for i, (ind, col_name, col_type) in enumerate(t["cols"]):
        ry = y + HEADER_H + i * ROW_H
        if i % 2 == 0:
            p.append(f'<rect x="{x+1}" y="{ry}" width="{w-2}" height="{ROW_H}" fill="{ROW_ALT}"/>')
        ty = ry + 15
        if ind == "PK":
            p.append(f'<text x="{x+5}" y="{ty}" font-family="monospace" font-size="9" '
                     f'font-weight="700" fill="{PK_COLOR}">PK</text>')
            tcol = PK_COLOR
        elif ind == "FK":
            p.append(f'<text x="{x+5}" y="{ty}" font-family="monospace" font-size="9" '
                     f'font-weight="700" fill="{FK_COLOR}">FK</text>')
            tcol = FK_COLOR
        else:
            tcol = COL_COLOR
        p.append(f'<text x="{x+26}" y="{ty}" font-family="JetBrains Mono,monospace" '
                 f'font-size="11" fill="{tcol}">{col_name}</text>')
        p.append(f'<text x="{x+w-4}" y="{ty}" text-anchor="end" '
                 f'font-family="JetBrains Mono,monospace" font-size="9" fill="{TYPE_CLR}">{col_type}</text>')
    return "\n".join(p)


def edge_points(child, parent):
    """Return best (x1,y1, x2,y2) connection edge pair."""
    c, pa = child, parent
    ch = th(c); ph = th(pa)

    cr = c["x"] + c["w"]; cl = c["x"]
    pr = pa["x"] + pa["w"]; pl = pa["x"]
    cmx = c["x"] + c["w"]//2; cmy = c["y"] + ch//2
    pmx = pa["x"] + pa["w"]//2; pmy = pa["y"] + ph//2

    if cl > pr:          # child right of parent
        return (cl, cmy, pr, pmy)
    elif cr < pl:        # child left of parent
        return (cr, cmy, pl, pmy)
    elif c["y"] > pa["y"] + ph:   # child below parent
        return (cmx, c["y"], pmx, pa["y"] + ph)
    elif c["y"] + ch < pa["y"]:   # child above parent
        return (cmx, c["y"] + ch, pmx, pa["y"])
    else:                # overlapping fallback
        return (cr, cmy, pl, pmy)


def draw_relation(child_name, parent_name):
    c = TABLES[child_name]; pa = TABLES[parent_name]
    x1, y1, x2, y2 = edge_points(c, pa)
    # Cubic bezier — horizontal or vertical bias
    dx = abs(x2 - x1); dy = abs(y2 - y1)
    if dx >= dy:
        mx = (x1 + x2) / 2
        d = f"M {x1} {y1} C {mx} {y1}, {mx} {y2}, {x2} {y2}"
    else:
        my = (y1 + y2) / 2
        d = f"M {x1} {y1} C {x1} {my}, {x2} {my}, {x2} {y2}"
    return (f'<path d="{d}" fill="none" stroke="{REL_CLR}" '
            f'stroke-width="1.5" stroke-dasharray="5,3" marker-end="url(#arr)"/>')


# ── Ensamble SVG ──────────────────────────────────────────────────────────────
rels  = "\n".join(draw_relation(c, p) for c, p in RELATIONS)
tbls  = "\n".join(draw_table(n, t) for n, t in TABLES.items())

svg = f'''<svg xmlns="http://www.w3.org/2000/svg"
     viewBox="0 0 1545 1115"
     width="1545" height="1115">

<defs>
  <style>
    svg {{ background: {BG}; }}
    text {{ font-family: "JetBrains Mono", "Courier New", monospace; }}
  </style>
  <marker id="arr" markerWidth="8" markerHeight="7" refX="7" refY="3.5" orient="auto">
    <polygon points="0 0, 8 3.5, 0 7" fill="{REL_CLR}"/>
  </marker>
</defs>

<!-- Background -->
<rect width="1545" height="1115" fill="{BG}"/>

<!-- Zone: Geografía -->
<rect x="8" y="12" width="1207" height="138" rx="6"
      fill="none" stroke="#1e3248" stroke-width="1" stroke-dasharray="6,4"/>
<text x="15" y="163" font-size="10" fill="#3a5a78">GEOGRAFÍA</text>

<!-- Zone: Seguridad -->
<rect x="1250" y="118" width="244" height="175" rx="6"
      fill="none" stroke="#1e3248" stroke-width="1" stroke-dasharray="6,4"/>
<text x="1257" y="307" font-size="10" fill="#3a5a78">SEGURIDAD</text>

<!-- Relation lines -->
{rels}

<!-- Tables -->
{tbls}

<!-- Title -->
<text x="772" y="1102" text-anchor="middle" font-size="12" fill="#4a6070">
  Diagrama ER · Hipódromo Nacional · IF-5100 UCR Liberia · 18 tablas · 22 triggers · 8 bitácoras particionadas
</text>
</svg>'''

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w", encoding="utf-8") as f:
    f.write(svg)
print(f"ER diagram generado: {OUT}")
