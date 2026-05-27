"""
Genera presentacion.html para el proyecto Hipódromo Nacional (Spring Boot).
Stack real: Spring Boot 3.5 + Spring Security + Thymeleaf + JPA + PostgreSQL + Supabase + Railway + Git
Reveal.js 4 — completamente autocontenido (sin internet necesario para las imágenes)
"""

import base64, io, os

try:
    import qrcode
except ImportError:
    import subprocess, sys
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'qrcode[pil]', '-q'])
    import qrcode

OUT = "presentacion.html"

def b64(path_or_buf, fmt='png'):
    if isinstance(path_or_buf, str):
        with open(path_or_buf, 'rb') as f:
            data = f.read()
    else:
        data = path_or_buf.read()
    return f"data:image/{fmt};base64," + base64.b64encode(data).decode()

qr = qrcode.QRCode(version=2, box_size=10, border=3,
                   error_correction=qrcode.constants.ERROR_CORRECT_M)
qr.add_data("https://github.com/kendallquirosalvarez-prog/hipodromoNacional")
qr.make(fit=True)
qr_img = qr.make_image(fill_color="#58A6FF", back_color="#0D1117")
qr_buf = io.BytesIO(); qr_img.save(qr_buf, format='PNG'); qr_buf.seek(0)
QR_SRC = b64(qr_buf)

HTML = f"""<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hipódromo Nacional — IF-5100 UCR</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4.6.1/dist/reset.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4.6.1/dist/reveal.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4.6.1/dist/theme/black.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">

<style>
:root {{
  --bg:      #0d1117;
  --bg2:     #161b27;
  --bg3:     #1c2333;
  --blue:    #58a6ff;
  --green:   #3fb950;
  --orange:  #ffa657;
  --red:     #f78166;
  --gold:    #ffd700;
  --white:   #f0f6fc;
  --gray:    #8b949e;
  --border:  #30363d;
}}

.reveal {{ background: var(--bg); font-family: 'Inter', sans-serif; }}
.reveal .slides section {{ text-align: left; padding: 0; }}
.reveal h1, .reveal h2, .reveal h3 {{ font-family: 'Inter', sans-serif; letter-spacing: -0.02em; }}

.slide-inner {{
  width: 100%; height: 100vh;
  display: flex; flex-direction: column;
  padding: 2.4rem 3rem 1.4rem;
  box-sizing: border-box;
  position: relative; overflow: hidden;
}}
.slide-inner::before {{
  content: '';
  position: absolute; top: 0; left: 0; right: 0; height: 4px;
  background: linear-gradient(90deg, var(--blue), var(--green));
}}

.slide-title {{
  font-size: 2rem; font-weight: 800;
  color: var(--white); margin: 0 0 0.2rem; line-height: 1.1;
}}
.slide-sub {{
  font-size: 0.95rem; color: var(--gray);
  font-style: italic; margin: 0 0 1rem;
}}
.divider {{
  height: 2px; border: none;
  background: linear-gradient(90deg, var(--blue) 0%, transparent 100%);
  margin: 0 0 1.4rem;
}}

.cards {{ display: grid; gap: 1rem; flex: 1; }}
.cards-2 {{ grid-template-columns: 1fr 1fr; }}
.cards-3 {{ grid-template-columns: repeat(3, 1fr); }}
.cards-4 {{ grid-template-columns: repeat(4, 1fr); }}

.card {{
  background: var(--bg2); border: 1px solid var(--border);
  border-radius: 10px; padding: 1.2rem 1.1rem;
  position: relative; overflow: hidden;
}}
.card::before {{
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
}}
.card.blue::before   {{ background: var(--blue); }}
.card.green::before  {{ background: var(--green); }}
.card.orange::before {{ background: var(--orange); }}
.card.red::before    {{ background: var(--red); }}
.card.gold::before   {{ background: var(--gold); }}
.card.purple::before {{ background: #bc8cff; }}

.card-icon  {{ font-size: 1.8rem; margin-bottom: 0.5rem; display: block; }}
.card-title {{ font-size: 1rem; font-weight: 700; color: var(--white); margin: 0 0 0.45rem; }}
.card-body  {{ font-size: 0.78rem; color: #adbac7; line-height: 1.55; }}

.pills {{ display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.8rem; }}
.pill {{
  padding: 0.3rem 0.9rem; border-radius: 999px;
  font-size: 0.78rem; font-weight: 600; border: 1px solid;
}}
.pill-blue   {{ color: var(--blue);   border-color: var(--blue);   background: #1c2d42; }}
.pill-green  {{ color: var(--green);  border-color: var(--green);  background: #142820; }}
.pill-orange {{ color: var(--orange); border-color: var(--orange); background: #2d1f0e; }}
.pill-gold   {{ color: var(--gold);   border-color: var(--gold);   background: #2a2200; }}
.pill-red    {{ color: var(--red);    border-color: var(--red);    background: #2d0e0e; }}

.code-block {{
  background: #010409; border: 1px solid var(--border);
  border-radius: 8px; padding: 1rem 1.2rem;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.72rem; line-height: 1.6;
  overflow-x: auto; color: #adbac7;
}}
.kw  {{ color: #ff7b72; }}
.fn  {{ color: #d2a8ff; }}
.str {{ color: #a5d6ff; }}
.cm  {{ color: #8b949e; font-style: italic; }}
.num {{ color: #ffa657; }}
.tp  {{ color: #79c0ff; }}
.an  {{ color: #3fb950; }}

.analogy {{
  background: linear-gradient(135deg, #1a1f0d 0%, #0d1117 100%);
  border-left: 3px solid var(--green); border-radius: 0 8px 8px 0;
  padding: 0.75rem 1rem; margin-top: 1rem;
  font-size: 0.82rem; color: var(--white); line-height: 1.5;
}}
.analogy strong {{ color: var(--green); }}

.slide-num {{
  position: absolute; bottom: 1rem; right: 2rem;
  font-size: 0.7rem; color: var(--gray);
}}

.cover-bg {{
  background: radial-gradient(ellipse at 30% 50%, #1c2d42 0%, var(--bg) 60%);
}}
.cover-title {{
  font-size: 3.4rem; font-weight: 800; color: var(--white);
  line-height: 1; margin: 0 0 0.6rem;
}}
.cover-accent {{ color: var(--blue); }}
.cover-sub {{ font-size: 1.3rem; color: var(--gray); margin: 0 0 2rem; }}
.cover-meta {{
  font-size: 0.85rem; color: var(--gray); margin-top: 2rem;
  border-top: 1px solid var(--border); padding-top: 1rem;
}}

.timeline {{ display: flex; gap: 0; flex: 1; align-items: stretch; }}
.tl-step {{
  flex: 1; position: relative;
  background: var(--bg2); border-top: 3px solid;
  padding: 1rem 0.9rem 0.9rem; border-radius: 0 0 8px 8px;
}}
.tl-step:not(:last-child)::after {{
  content: '→'; position: absolute; right: -0.7rem; top: 50%;
  transform: translateY(-50%);
  font-size: 1.2rem; color: var(--gray); z-index: 10;
}}
.tl-step.blue   {{ border-color: var(--blue); }}
.tl-step.green  {{ border-color: var(--green); }}
.tl-step.orange {{ border-color: var(--orange); }}
.tl-step.red    {{ border-color: var(--red); }}
.tl-step.gold   {{ border-color: var(--gold); }}
.tl-num {{ font-size: 2rem; font-weight: 800; opacity: 0.25; position: absolute; top: 0.5rem; right: 0.7rem; }}
.tl-icon  {{ font-size: 1.6rem; margin-bottom: 0.4rem; }}
.tl-title {{ font-size: 0.9rem; font-weight: 700; color: var(--white); margin-bottom: 0.4rem; }}
.tl-body  {{ font-size: 0.72rem; color: #adbac7; line-height: 1.55; }}

.arch-row {{
  display: flex; align-items: center; gap: 0.6rem;
  background: var(--bg2); border: 1px solid var(--border);
  border-radius: 8px; padding: 0.7rem 1rem; margin-bottom: 0.5rem;
}}
.arch-layer {{
  font-size: 0.85rem; font-weight: 700; min-width: 180px;
}}
.arch-arrow {{ color: var(--gray); font-size: 1.1rem; flex-shrink: 0; }}
.arch-detail {{ font-size: 0.75rem; color: #adbac7; flex: 1; line-height: 1.4; }}

.logros-list {{ display: flex; flex-direction: column; gap: 0.7rem; }}
.logro-item {{
  display: flex; align-items: flex-start; gap: 0.7rem;
  background: var(--bg2); border-radius: 8px;
  padding: 0.7rem 0.9rem; border-left: 3px solid var(--blue);
  font-size: 0.82rem; color: var(--white);
}}
.logro-icon {{ font-size: 1.1rem; flex-shrink: 0; margin-top: 0.05rem; }}

.closing-grid {{
  display: grid; grid-template-columns: 1fr auto;
  gap: 2rem; flex: 1; align-items: start;
}}
</style>
</head>

<body>
<div class="reveal">
<div class="slides">

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 1. PORTADA                                                  -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner cover-bg" style="justify-content:center;">
  <div style="max-width:72%;">
    <div style="font-size:3.5rem;margin-bottom:1rem;">🏇</div>
    <div class="cover-title">HIPÓDROMO<br><span class="cover-accent">NACIONAL</span></div>
    <div class="cover-sub">Sistema Web de Control de Carrera de Caballos</div>
    <hr class="divider">
    <div class="pills">
      <span class="pill pill-blue">Spring Boot 3.5</span>
      <span class="pill pill-blue">Spring Security</span>
      <span class="pill pill-green">Thymeleaf</span>
      <span class="pill pill-green">Spring Data JPA</span>
      <span class="pill pill-orange">PostgreSQL</span>
      <span class="pill pill-orange">Supabase</span>
      <span class="pill pill-gold">Railway</span>
      <span class="pill pill-red">Git / GitHub</span>
    </div>
    <div class="cover-meta">
      IF-5100 Administración de Bases de Datos &nbsp;·&nbsp;
      Universidad de Costa Rica &nbsp;·&nbsp; Sede Liberia &nbsp;·&nbsp; 2025–2026
    </div>
  </div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 2. ARQUITECTURA EN CAPAS (vista del usuario a la BD)       -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Arquitectura del Sistema</h2>
  <p class="slide-sub">Cómo fluye una petición desde el navegador hasta PostgreSQL en Supabase</p>
  <hr class="divider">

  <div style="flex:1; display:flex; flex-direction:column; justify-content:center;">
    <div class="arch-row" style="border-left:3px solid var(--blue);">
      <div class="arch-layer" style="color:var(--blue);">🌐 Navegador (Usuario)</div>
      <div class="arch-arrow">→</div>
      <div class="arch-detail">Abre <code>https://hipodromo.railway.app</code> · HTML generado por el servidor · Sin JavaScript pesado</div>
    </div>
    <div style="text-align:center;font-size:1.3rem;color:var(--gray);margin:0.3rem 0;">↕</div>
    <div class="arch-row" style="border-left:3px solid var(--green);">
      <div class="arch-layer" style="color:var(--green);">🔒 Spring Security</div>
      <div class="arch-arrow">→</div>
      <div class="arch-detail">Intercepta cada petición · Verifica sesión activa · Redirige a <code>/login</code> si no autenticado · Aplica reglas de rol por URL</div>
    </div>
    <div style="text-align:center;font-size:1.3rem;color:var(--gray);margin:0.3rem 0;">↕</div>
    <div class="arch-row" style="border-left:3px solid var(--orange);">
      <div class="arch-layer" style="color:var(--orange);">⚙️ Controllers (MVC)</div>
      <div class="arch-arrow">→</div>
      <div class="arch-detail">Recibe la petición HTTP · Llama al Repository · Agrega datos al Model · Devuelve nombre de template Thymeleaf</div>
    </div>
    <div style="text-align:center;font-size:1.3rem;color:var(--gray);margin:0.3rem 0;">↕</div>
    <div class="arch-row" style="border-left:3px solid var(--gold);">
      <div class="arch-layer" style="color:var(--gold);">📦 Spring Data JPA</div>
      <div class="arch-arrow">→</div>
      <div class="arch-detail">Repositorios con <code>@Query(nativeQuery=true)</code> · Invoca stored procedures: <code>CALL sp_insertar_caballo(...)</code></div>
    </div>
    <div style="text-align:center;font-size:1.3rem;color:var(--gray);margin:0.3rem 0;">↕</div>
    <div class="arch-row" style="border-left:3px solid var(--red);">
      <div class="arch-layer" style="color:var(--red);">🗃️ PostgreSQL (Supabase)</div>
      <div class="arch-arrow">→</div>
      <div class="arch-detail">18 tablas · Stored procedures con lógica de negocio · 22 triggers de auditoría · 8 bitácoras particionadas por trimestre</div>
    </div>
  </div>
  <div class="slide-num">2 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 3. SPRING BOOT — QUÉ ES Y CÓMO FUNCIONA                   -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Spring Boot — El Motor del Sistema</h2>
  <p class="slide-sub">Framework Java que convierte código en una aplicación web lista para producción</p>
  <hr class="divider">

  <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; flex:1;">
    <div style="display:flex; flex-direction:column; gap:0.8rem;">
      <div class="card blue">
        <div class="card-title">🚀 Sin configuración manual</div>
        <div class="card-body">
          Un solo archivo <code style="color:var(--blue)">application.properties</code> configura
          todo: base de datos, puerto, seguridad.<br><br>
          No hace falta instalar un servidor web — Spring Boot incluye
          <b>Tomcat embebido</b> dentro del JAR.
        </div>
      </div>
      <div class="card green">
        <div class="card-title">🔄 Ciclo petición → respuesta</div>
        <div class="card-body">
          <b style="color:var(--white)">1.</b> Llega GET /caballos<br>
          <b style="color:var(--white)">2.</b> Security verifica rol<br>
          <b style="color:var(--white)">3.</b> CaballoController llama al repository<br>
          <b style="color:var(--white)">4.</b> JPA ejecuta la consulta en Supabase<br>
          <b style="color:var(--white)">5.</b> Thymeleaf renderiza <code>caballos/index.html</code><br>
          <b style="color:var(--white)">6.</b> HTML final al navegador
        </div>
      </div>
    </div>

    <div class="code-block" style="font-size:0.66rem; overflow-y:auto;">
<span class="cm"># application.properties — toda la configuración en un lugar</span>
server.port=${{PORT:8080}}

<span class="cm"># Supabase (variables de entorno en Railway)</span>
spring.datasource.url=${{DB_URL}}
spring.datasource.username=${{DB_USERNAME}}
spring.datasource.password=${{DB_PASSWORD}}

spring.jpa.hibernate.ddl-auto=<span class="str">none</span>
spring.jpa.database-platform=
  org.hibernate.<span class="fn">dialect</span>.PostgreSQLDialect

<span class="cm">// Controller — recibe HTTP, llama JPA, devuelve vista</span>
<span class="an">@Controller</span>
<span class="an">@RequestMapping</span>(<span class="str">"/caballos"</span>)
<span class="kw">public class</span> <span class="tp">CaballoController</span> {{

  <span class="an">@Autowired</span>
  <span class="kw">private</span> <span class="tp">CaballoRepository</span> repo;

  <span class="an">@GetMapping</span>
  <span class="kw">public</span> String <span class="fn">listar</span>(<span class="tp">Model</span> model) {{
    model.<span class="fn">addAttribute</span>(<span class="str">"caballos"</span>,
        repo.<span class="fn">findAll</span>());
    <span class="kw">return</span> <span class="str">"caballos/index"</span>;
  }}

  <span class="an">@PostMapping</span>(<span class="str">"/guardar"</span>)
  <span class="kw">public</span> String <span class="fn">guardar</span>(
      <span class="an">@ModelAttribute</span> <span class="tp">Caballo</span> c) {{
    repo.<span class="fn">insertarCaballo</span>(c.<span class="fn">getId</span>(), ...);
    <span class="kw">return</span> <span class="str">"redirect:/caballos"</span>;
  }}
}}
    </div>
  </div>

  <div class="analogy">
    <strong>💡 Analogía:</strong>
    Spring Boot es como una cocina industrial lista para usar —
    los electrodomésticos (Tomcat, JPA, Security) ya están instalados y conectados.
    Solo tenés que traer los ingredientes (tu código).
  </div>
  <div class="slide-num">3 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 4. GIT Y GITHUB — CONTROL DE VERSIONES                    -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Git y GitHub — Historial del Proyecto</h2>
  <p class="slide-sub">Cada cambio queda registrado · Trabajo en equipo sin pisarse el código</p>
  <hr class="divider">

  <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; flex:1;">
    <div style="display:flex; flex-direction:column; gap:0.8rem;">
      <div class="card orange">
        <div class="card-title">📁 ¿Qué hace Git?</div>
        <div class="card-body">
          Guarda <b>instantáneas</b> (commits) del proyecto en cada punto importante.<br><br>
          Si algo se rompe, podés volver a cualquier commit anterior con <code style="color:var(--orange)">git checkout</code>.<br><br>
          Cada commit tiene: qué cambió, quién lo hizo y cuándo.
        </div>
      </div>
      <div class="card blue">
        <div class="card-title">☁️ GitHub = Git en la nube</div>
        <div class="card-body">
          El repositorio local se sincroniza con GitHub.<br><br>
          Railway lee directamente de GitHub — cada <code style="color:var(--blue)">git push</code>
          dispara un nuevo despliegue automático en producción.
        </div>
      </div>
    </div>

    <div class="code-block" style="font-size:0.68rem; overflow-y:auto;">
<span class="cm"># Flujo de trabajo del proyecto</span>

<span class="cm"># 1. Ver qué cambió</span>
git status
git diff

<span class="cm"># 2. Preparar los cambios</span>
git add src/main/java/...
git add src/main/resources/...

<span class="cm"># 3. Guardar el commit con mensaje</span>
git commit -m <span class="str">"feat: agregar módulo Suministros"</span>

<span class="cm"># 4. Subir a GitHub (dispara Railway)</span>
git push origin main

<span class="cm"># Historial del proyecto Hipódromo</span>
<span class="num">6627052</span> Agregar página ER y procedimientos
<span class="num">9178de4</span> Corregir autenticación DelegatingPasswordEncoder
<span class="num">a886c6f</span> Cambiar rol Justin Marenco a ROLE_ADMIN
<span class="num">2c7c076</span> Agregar Spring Security con roles
<span class="num">25766be</span> Rediseño visual — tema oscuro dorado
<span class="num">e7c051d</span> Proyecto final IF-5100 — Sistema Hipódromo
    </div>
  </div>

  <div class="analogy">
    <strong>💡 Analogía:</strong>
    Git es como el historial de un documento de Google Docs —
    podés ver cada versión anterior y restaurar cualquiera.
    GitHub es el Google Drive donde se guarda en la nube.
  </div>
  <div class="slide-num">4 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 5. SUPABASE + RAILWAY — INFRAESTRUCTURA EN LA NUBE        -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Supabase y Railway — La Nube</h2>
  <p class="slide-sub">Base de datos y servidor web, ambos gratuitos y siempre disponibles</p>
  <hr class="divider">

  <div class="cards cards-2" style="flex:1;">
    <div class="card green">
      <span class="card-icon">🗄️</span>
      <div class="card-title">Supabase — PostgreSQL en la nube</div>
      <div class="card-body">
        Provee un servidor PostgreSQL completamente administrado.<br><br>
        El proyecto se conecta con la URL de Supabase en lugar de una BD local
        — funciona igual en la laptop y en producción.<br><br>
        <span style="color:var(--green)">URL de conexión →</span>
        <code style="color:#adbac7;font-size:0.68rem;">jdbc:postgresql://aws-1...supabase.com:6543/postgres</code><br><br>
        Schema Visualizer, Dashboard SQL, backups automáticos incluidos.
      </div>
      <div class="pills" style="margin-top:0.8rem;">
        <span class="pill pill-green">PostgreSQL 15</span>
        <span class="pill pill-green">Pool de conexiones</span>
        <span class="pill pill-green">SSL forzado</span>
      </div>
    </div>

    <div class="card gold">
      <span class="card-icon">🚄</span>
      <div class="card-title">Railway — Servidor web en la nube</div>
      <div class="card-body">
        Ejecuta el JAR de Spring Boot en un contenedor Docker.<br><br>
        <b style="color:var(--white)">Despliegue automático:</b><br>
        <code>git push</code> → Railway detecta el cambio →
        compila el proyecto → reinicia el servidor → nuevo código activo en ~2 min.<br><br>
        Las variables de entorno (<code>DB_URL</code>, <code>DB_PASSWORD</code>, <code>PORT</code>)
        se configuran en Railway — nunca en el código.
      </div>
      <div class="pills" style="margin-top:0.8rem;">
        <span class="pill pill-gold">Docker</span>
        <span class="pill pill-gold">CI/CD automático</span>
        <span class="pill pill-gold">Variables de entorno</span>
      </div>
    </div>
  </div>

  <div class="analogy" style="margin-top:0.9rem;">
    <strong>💡 Analogía:</strong>
    Supabase es como contratar un DBA 24/7 que administra tu servidor de base de datos.
    Railway es como contratar el local donde pones tu negocio — vos solo ponés la aplicación,
    ellos manejan la electricidad, seguridad y mantenimiento.
  </div>
  <div class="slide-num">5 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 6. SPRING SECURITY — AUTENTICACIÓN Y ROLES                 -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Spring Security — Acceso Controlado</h2>
  <p class="slide-sub">Cada rol solo ve lo que necesita · Contraseñas encriptadas con BCrypt</p>
  <hr class="divider">

  <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; flex:1;">
    <div style="display:flex; flex-direction:column; gap:0.7rem;">
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.6rem;">
        <div class="card" style="border-top:3px solid #c62428;">
          <div style="font-size:1.5rem;margin-bottom:0.3rem;">👑</div>
          <div style="font-weight:700;color:var(--white);font-size:0.85rem;">ADMIN</div>
          <div style="font-size:0.7rem;color:#adbac7;margin-top:0.3rem;">Acceso total a todos los módulos</div>
        </div>
        <div class="card" style="border-top:3px solid var(--blue);">
          <div style="font-size:1.5rem;margin-bottom:0.3rem;">💉</div>
          <div style="font-weight:700;color:var(--white);font-size:0.85rem;">VETERINARIO</div>
          <div style="font-size:0.7rem;color:#adbac7;margin-top:0.3rem;">Historial vet. y alertas</div>
        </div>
        <div class="card" style="border-top:3px solid var(--orange);">
          <div style="font-size:1.5rem;margin-bottom:0.3rem;">🤝</div>
          <div style="font-weight:700;color:var(--white);font-size:0.85rem;">PROPIETARIO</div>
          <div style="font-size:0.7rem;color:#adbac7;margin-top:0.3rem;">Caballos, inscripciones, facturas</div>
        </div>
        <div class="card" style="border-top:3px solid var(--green);">
          <div style="font-size:1.5rem;margin-bottom:0.3rem;">🌾</div>
          <div style="font-weight:700;color:var(--white);font-size:0.85rem;">ENCARGADO</div>
          <div style="font-size:0.7rem;color:#adbac7;margin-top:0.3rem;">Establos, suministros, alimentación</div>
        </div>
      </div>
      <div class="analogy" style="margin-top:0.4rem;">
        <strong>💡</strong> Los usuarios y contraseñas se guardan en la tabla
        <code>usuarios</code> de Supabase. Spring Security los lee vía
        <code>UsuarioDetailsService</code> — no hay lista hardcodeada en el código.
      </div>
    </div>

    <div class="code-block" style="font-size:0.64rem; overflow-y:auto;">
<span class="cm">// SecurityConfig — reglas de acceso por URL y rol</span>
http.<span class="fn">authorizeHttpRequests</span>(auth -> auth
  .<span class="fn">requestMatchers</span>(<span class="str">"/login"</span>)
    .<span class="fn">permitAll</span>()
  .<span class="fn">requestMatchers</span>(<span class="str">"/historial/**"</span>,
                  <span class="str">"/alertas/**"</span>)
    .<span class="fn">hasAnyRole</span>(<span class="str">"ADMIN"</span>,<span class="str">"VETERINARIO"</span>)
  .<span class="fn">requestMatchers</span>(<span class="str">"/establos/**"</span>, <span class="str">"/suministros/**"</span>,
                  <span class="str">"/alimentacion/**"</span>)
    .<span class="fn">hasAnyRole</span>(<span class="str">"ADMIN"</span>,<span class="str">"ENCARGADO"</span>)
  .<span class="fn">requestMatchers</span>(<span class="str">"/caballos/**"</span>, <span class="str">"/facturas/**"</span>,
                  <span class="str">"/inscripciones/**"</span>, <span class="str">"/resultados/**"</span>)
    .<span class="fn">hasAnyRole</span>(<span class="str">"ADMIN"</span>,<span class="str">"PROPIETARIO"</span>)
  .<span class="fn">anyRequest</span>().<span class="fn">authenticated</span>()
)
.<span class="fn">formLogin</span>(form -> form
  .<span class="fn">loginPage</span>(<span class="str">"/login"</span>)
  .<span class="fn">defaultSuccessUrl</span>(<span class="str">"/"</span>, <span class="kw">true</span>)
)
.<span class="fn">logout</span>(logout -> logout
  .<span class="fn">logoutSuccessUrl</span>(<span class="str">"/login?logout"</span>)
);

<span class="cm">// BCrypt: la contraseña nunca se guarda en texto plano</span>
<span class="an">@Bean</span>
<span class="kw">public</span> <span class="tp">PasswordEncoder</span> <span class="fn">passwordEncoder</span>() {{
  <span class="kw">return</span> PasswordEncoderFactories
    .<span class="fn">createDelegatingPasswordEncoder</span>();
}}
    </div>
  </div>
  <div class="slide-num">6 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 7. THYMELEAF — VISTAS DEL SERVIDOR                        -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Thymeleaf — Las Vistas</h2>
  <p class="slide-sub">HTML que se procesa en el servidor e incluye datos reales antes de llegar al navegador</p>
  <hr class="divider">

  <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; flex:1;">
    <div style="display:flex; flex-direction:column; gap:0.8rem;">
      <div class="card blue">
        <div class="card-title">🔄 Server-Side Rendering</div>
        <div class="card-body">
          El servidor combina la plantilla HTML con los datos de la BD
          y envía HTML completo al navegador.<br><br>
          No hay API REST, no hay React, no hay JavaScript para cargar datos.
          Lo que el usuario ve ya contiene los registros reales.
        </div>
      </div>
      <div class="card green">
        <div class="card-title">🔐 th:sec — Integración con Security</div>
        <div class="card-body">
          <code style="color:var(--green)">sec:authorize="hasRole('ADMIN')"</code><br>
          oculta elementos del HTML según el rol activo —
          el botón "Eliminar" solo aparece para ADMIN,
          aunque el usuario intente manipular la URL.
        </div>
      </div>
    </div>

    <div class="code-block" style="font-size:0.66rem; overflow-y:auto;">
<span class="cm">&lt;!-- caballos/index.html — tabla dinámica con datos reales --&gt;</span>
&lt;<span class="kw">tr</span> <span class="an">th:each</span>=<span class="str">"c : ${{caballos}}"</span>&gt;
  &lt;<span class="kw">td</span> <span class="an">th:text</span>=<span class="str">"${{c.nombre}}"</span>&gt;&lt;/<span class="kw">td</span>&gt;
  &lt;<span class="kw">td</span>&gt;
    &lt;<span class="kw">span</span>
      <span class="an">th:class</span>=<span class="str">"${{c.estadoSalud == 'Óptimo'}}
               ? 'badge badge-green'
               : 'badge badge-red'"</span>
      <span class="an">th:text</span>=<span class="str">"${{c.estadoSalud}}"</span>&gt;
    &lt;/<span class="kw">span</span>&gt;
  &lt;/<span class="kw">td</span>&gt;
  <span class="cm">&lt;!-- Solo ADMIN ve el botón eliminar --&gt;</span>
  &lt;<span class="kw">td</span> <span class="an">sec:authorize</span>=<span class="str">"hasRole('ADMIN')"</span>&gt;
    &lt;<span class="kw">a</span> <span class="an">th:href</span>=<span class="str">"@{{/caballos/eliminar/${{c.idCaballo}}}}"</span>
       <span class="kw">class</span>=<span class="str">"btn-delete"</span>&gt;
      Eliminar
    &lt;/<span class="kw">a</span>&gt;
  &lt;/<span class="kw">td</span>&gt;
&lt;/<span class="kw">tr</span>&gt;
    </div>
  </div>

  <div class="analogy">
    <strong>💡 Analogía:</strong>
    Thymeleaf es como una plantilla de Word con campos de combinación de correspondencia
    — el documento base ya está hecho, solo se llenan los datos
    (nombre, precio, fecha) antes de imprimir.
  </div>
  <div class="slide-num">7 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 8. BASE DE DATOS — 14 TABLAS Y STORED PROCEDURES          -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Base de Datos PostgreSQL</h2>
  <p class="slide-sub">18 tablas normalizadas · Toda la lógica de negocio vive en stored procedures</p>
  <hr class="divider">

  <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; flex:1;">
    <div style="display:flex; flex-direction:column; gap:0.75rem;">
      <div class="card blue">
        <div class="card-title">📊 18 Tablas del sistema</div>
        <div class="card-body" style="display:grid;grid-template-columns:1fr 1fr;gap:0.2rem 0.6rem;font-size:0.72rem;">
          <span>• Propietarios</span><span>• Establos</span>
          <span>• Caballos</span><span>• Eventos</span>
          <span>• Inscripciones</span><span>• Resultados</span>
          <span>• Hist.Veterinario</span><span>• Alertas Vet.</span>
          <span>• Suministros</span><span>• Alimentación</span>
          <span>• Facturas</span><span>• Transacciones</span>
          <span>• Pais · Provincia</span><span>• Canton · Distrito</span>
          <span>• Barrio</span><span>• Usuarios</span>
        </div>
      </div>
      <div class="card orange">
        <div class="card-title">⚙️ Stored Procedures con prefijo sp_</div>
        <div class="card-body">
          Spring Data JPA llama a procedimientos con <code style="color:var(--orange)">@Query(nativeQuery=true)</code><br><br>
          <code>CALL sp_insertar_caballo(:p_id, :p_nombre, ...)</code><br><br>
          La lógica de negocio vive en la BD — si cambia la regla,
          solo se actualiza el procedure sin tocar Java.
        </div>
      </div>
    </div>

    <div class="code-block" style="font-size:0.66rem; overflow-y:auto;">
<span class="cm">-- Ejemplo: sp_insertar_alimentacion</span>
<span class="cm">-- Descuenta stock de suministros al registrar ración</span>
<span class="kw">CREATE OR REPLACE PROCEDURE</span>
  <span class="fn">sp_insertar_alimentacion</span>(
    p_id_caballo    <span class="tp">VARCHAR</span>,
    p_id_suministro <span class="tp">VARCHAR</span>,
    p_tipo_alimento <span class="tp">VARCHAR</span>,
    p_cantidad      <span class="tp">DECIMAL</span>,
    p_fecha         <span class="tp">DATE</span>
  )
<span class="kw">LANGUAGE</span> plpgsql <span class="kw">AS</span> $$
<span class="kw">BEGIN</span>
  <span class="kw">INSERT INTO</span> <span class="tp">alimentacion</span>
    (id_caballo, id_suministro, tipo_alimento,
     cantidad, fecha)
  <span class="kw">VALUES</span>
    (p_id_caballo, p_id_suministro,
     p_tipo_alimento, p_cantidad, p_fecha);

  <span class="cm">-- Descuenta automáticamente del inventario</span>
  <span class="kw">UPDATE</span> <span class="tp">suministro</span>
     <span class="kw">SET</span> cantidad_disponible =
         cantidad_disponible - p_cantidad
   <span class="kw">WHERE</span> id_suministro = p_id_suministro;
<span class="kw">END</span>; $$;
    </div>
  </div>
  <div class="slide-num">8 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 9. AUTOMATIZACIÓN — TRIGGERS Y BITÁCORAS                  -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Automatización — Triggers y Bitácoras</h2>
  <p class="slide-sub">La base de datos trabaja sola — auditoría completa sin intervención del programador</p>
  <hr class="divider">

  <div class="cards cards-4" style="flex:1;">
    <div class="card purple">
      <span class="card-icon">📋</span>
      <div class="card-title">8 Bitácoras Particionadas</div>
      <div class="card-body">
        8 tablas × 4 trimestres<br>
        Cada partición filtra por rango de fechas — consultar Q2 no toca registros del Q1<br><br>
        <span style="color:#bc8cff">Implementado en PostgreSQL, transparente para Spring Boot</span>
      </div>
    </div>
    <div class="card blue">
      <span class="card-icon">🔍</span>
      <div class="card-title">22 Triggers en Total</div>
      <div class="card-body">
        12 de auditoría (1 por tabla)<br>
        8 de bitácoras particionadas<br>
        + alerta vencimiento cert.<br>
        + descuento cliente frecuente
      </div>
    </div>
    <div class="card green">
      <span class="card-icon">🔔</span>
      <div class="card-title">Alerta Vencimiento</div>
      <div class="card-body">
        Trigger AFTER UPDATE en Caballos<br><br>
        Si la certificación vence en menos de 30 días,
        inserta automáticamente en <code style="color:var(--green)">alerta_veterinaria</code>
      </div>
    </div>
    <div class="card orange">
      <span class="card-icon">💰</span>
      <div class="card-title">Descuento Frecuentes</div>
      <div class="card-body">
        Trigger BEFORE INSERT en Facturas<br><br>
        &gt;₡500k facturados en 6 meses →
        aplica 10% de descuento automático en la próxima factura
      </div>
    </div>
  </div>

  <div class="analogy" style="margin-top:0.9rem;">
    <strong>💡 Dato clave:</strong>
    Los triggers corren en PostgreSQL, <b>no en Spring Boot</b>.
    El controller solo llama <code>sp_insertar_alimentacion()</code> —
    la auditoría, el descuento y las alertas ocurren automáticamente en la BD.
  </div>
  <div class="slide-num">9 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 10. FACTURACIÓN — IVA 13%                                  -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Facturación — Ley 9635 Costa Rica</h2>
  <p class="slide-sub">IVA 13% calculado automáticamente · Historial de pagos por transacción</p>
  <hr class="divider">

  <div style="display:flex; align-items:center; gap:0.5rem; margin-bottom:1.2rem; flex-wrap:wrap;">
    {"".join(f'<div style="flex:1;background:var(--bg2);border:1px solid var(--border);border-radius:8px;padding:0.7rem 0.4rem;text-align:center;min-width:100px;"><div style="font-size:1.4rem;font-weight:800;color:{c};margin-bottom:0.2rem;">{v}</div><div style="font-size:0.68rem;color:var(--gray);">{l}</div></div><div style="font-size:1.2rem;color:var(--gray);padding:0 0.3rem;flex-shrink:0;">{op}</div>' for v,l,c,op in [
      ("₡150,000","Precio inscripción","var(--blue)","+"),
      ("5%","Comisión admin.","var(--orange)","−"),
      ("10%*","Desc. frecuente","var(--green)","×"),
      ("13%","IVA Ley 9635","var(--red)","="),
      ("TOTAL","Factura final","var(--gold)",""),
    ])}
  </div>
  <p style="font-size:0.72rem;color:var(--gray);margin:0 0 0.8rem;">* Solo aplica si el propietario supera ₡500,000 en los últimos 6 meses</p>

  <div class="code-block" style="flex:1;overflow-y:auto;font-size:0.68rem;">
<span class="cm">-- Vista resumen de facturas con cálculo IVA visible</span>
<span class="kw">SELECT</span>
  (p.nombre || <span class="str">' '</span> || p.apellidos) <span class="kw">AS</span> propietario,
  e.nombre         <span class="kw">AS</span> evento,
  f.subtotal,
  f.descuento,
  (f.subtotal - f.descuento)   <span class="kw">AS</span> base_imponible,
  f.impuestos                  <span class="kw">AS</span> iva_13pct,
  f.total,
  <span class="kw">CASE WHEN</span> f.descuento &gt; <span class="num">0</span>
       <span class="kw">THEN</span> <span class="str">'Sí (cliente frecuente)'</span>
       <span class="kw">ELSE</span> <span class="str">'No'</span>
  <span class="kw">END AS</span> descuento_aplicado,
  f.estado_pago
<span class="kw">FROM</span> <span class="tp">factura</span> f
<span class="kw">JOIN</span> <span class="tp">propietario</span> p <span class="kw">ON</span> p.id_propietario = f.id_propietario
<span class="kw">JOIN</span> <span class="tp">evento</span> e <span class="kw">ON</span> e.id_evento = f.id_evento
<span class="kw">ORDER BY</span> f.fecha_emision <span class="kw">DESC</span>;
  </div>
  <div class="slide-num">10 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 11. MÓDULOS DEL SISTEMA                                    -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">12 Módulos del Sistema</h2>
  <p class="slide-sub">Cada módulo: formulario de registro, tabla con lista, editar y eliminar</p>
  <hr class="divider">

  <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:0.65rem; flex:1;">
    {"".join(f'<div style="background:var(--bg2);border:1px solid var(--border);border-radius:8px;padding:0.8rem;position:relative;overflow:hidden;"><div style="position:absolute;top:0;left:0;right:0;height:2px;background:{c};"></div><div style="font-size:1.4rem;margin-bottom:0.3rem;">{ic}</div><div style="font-size:0.82rem;font-weight:700;color:var(--white);margin-bottom:0.2rem;">{name}</div><div style="font-size:0.65rem;color:var(--gray);">{desc}</div></div>' for ic,name,desc,c in [
      ("👤","Propietarios","CRUD completo","#58a6ff"),
      ("🏠","Establos","Estado y capacidad","#3fb950"),
      ("🐎","Caballos","Salud y propietario","#ffa657"),
      ("🏁","Eventos","Carreras y premios","#58a6ff"),
      ("📋","Inscripciones","Caballo + Evento","#3fb950"),
      ("🏆","Resultados","Posiciones y premios","#ffd700"),
      ("💰","Facturas","IVA + descuentos","#ffa657"),
      ("💳","Transacciones","Pagos de facturas","#f78166"),
      ("🩺","Historial Vet.","Diagnósticos","#bc8cff"),
      ("🔔","Alertas Vet.","Vencimientos","#58a6ff"),
      ("📦","Suministros","Inventario","#3fb950"),
      ("🌾","Alimentación","Raciones diarias","#ffa657"),
    ])}
  </div>
  <div class="slide-num">11 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 12. CÓMO SE CONSTRUYÓ — 5 FASES                           -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner">
  <h2 class="slide-title">Proceso de Construcción</h2>
  <p class="slide-sub">5 fases ordenadas — cada una depende de la anterior</p>
  <hr class="divider">

  <div class="timeline" style="flex:1;">
    <div class="tl-step blue">
      <div class="tl-num">1</div>
      <div class="tl-icon">📐</div>
      <div class="tl-title">Diseño BD</div>
      <div class="tl-body">
        Diagrama ER<br>
        Normalización 3FN<br>
        DDL: 18 tablas<br>
        Constraints FK
      </div>
    </div>
    <div class="tl-step green">
      <div class="tl-num">2</div>
      <div class="tl-icon">⚙️</div>
      <div class="tl-title">Lógica PostgreSQL</div>
      <div class="tl-body">
        Stored procedures<br>
        8 bitácoras particionadas<br>
        22 triggers<br>
        Roles y permisos
      </div>
    </div>
    <div class="tl-step orange">
      <div class="tl-num">3</div>
      <div class="tl-icon">🌱</div>
      <div class="tl-title">Spring Boot</div>
      <div class="tl-body">
        Proyecto Maven<br>
        Modelos JPA<br>
        Repositorios<br>
        Controllers MVC
      </div>
    </div>
    <div class="tl-step red">
      <div class="tl-num">4</div>
      <div class="tl-icon">🔒</div>
      <div class="tl-title">Spring Security</div>
      <div class="tl-body">
        Login personalizado<br>
        4 roles definidos<br>
        Reglas por URL<br>
        BCrypt en contraseñas
      </div>
    </div>
    <div class="tl-step gold">
      <div class="tl-num">5</div>
      <div class="tl-icon">🚀</div>
      <div class="tl-title">Git + Railway</div>
      <div class="tl-body">
        GitHub repo público<br>
        Railway conectado<br>
        Supabase cloud<br>
        CI/CD automático
      </div>
    </div>
  </div>

  <div class="analogy" style="margin-top:0.9rem;">
    <strong>💡 Regla de oro:</strong> no se escribe código Java sin que el stored procedure ya exista y funcione en Supabase.
    El servidor de aplicaciones es el cliente de la base de datos, no al revés.
  </div>
  <div class="slide-num">12 / 13</div>
</div>
</section>

<!-- ══════════════════════════════════════════════════════════ -->
<!-- 13. CIERRE                                                  -->
<!-- ══════════════════════════════════════════════════════════ -->
<section>
<div class="slide-inner" style="background: radial-gradient(ellipse at 70% 50%, #1c2d42 0%, var(--bg) 60%);">
  <h2 class="slide-title">Resumen del Proyecto</h2>
  <hr class="divider">

  <div class="closing-grid">
    <div class="logros-list">
      <div class="logro-item"><span class="logro-icon">🗄️</span>18 tablas normalizadas hasta 3FN con constraints, FK y CHECK en PostgreSQL</div>
      <div class="logro-item"><span class="logro-icon">⚙️</span>Stored procedures para todo CRUD + lógica de negocio (IVA, descuentos, premios)</div>
      <div class="logro-item"><span class="logro-icon">📋</span>8 bitácoras particionadas por trimestre · 22 triggers de auditoría automática</div>
      <div class="logro-item"><span class="logro-icon">🌱</span>Spring Boot 3.5 con 12 módulos CRUD usando Thymeleaf + Spring Data JPA</div>
      <div class="logro-item"><span class="logro-icon">🔒</span>Spring Security con 4 roles, login propio y contraseñas BCrypt en Supabase</div>
      <div class="logro-item"><span class="logro-icon">🚀</span>Despliegue continuo: git push → Railway compila y publica en producción</div>
      <div class="logro-item"><span class="logro-icon">💳</span>Facturación con IVA 13% según Ley 9635 CR · Historial de transacciones</div>
    </div>

    <div style="display:flex;flex-direction:column;align-items:center;gap:0.8rem;min-width:200px;">
      <img src="{QR_SRC}" style="width:190px;height:190px;border-radius:10px;">
      <div style="font-size:0.72rem;color:var(--gray);text-align:center;">Repositorio GitHub<br>del proyecto</div>
      <div style="background:var(--bg2);border:1px solid var(--border);border-radius:6px;padding:0.6rem 1rem;text-align:center;">
        <div style="font-size:0.65rem;color:var(--gray);">UCR Sede Liberia · 2025–2026</div>
        <div style="font-size:0.72rem;color:var(--white);font-weight:600;">IF-5100 Bases de Datos</div>
      </div>
    </div>
  </div>
  <div class="slide-num">13 / 13</div>
</div>
</section>

</div><!-- /slides -->
</div><!-- /reveal -->

<script src="https://cdn.jsdelivr.net/npm/reveal.js@4.6.1/dist/reveal.js"></script>
<script>
Reveal.initialize({{
  hash: true,
  slideNumber: false,
  transition: 'fade',
  transitionSpeed: 'fast',
  backgroundTransition: 'fade',
  controls: true,
  progress: true,
  center: false,
  width: 1280,
  height: 720,
  margin: 0,
  minScale: 0.2,
  maxScale: 2.0,
}});
</script>
</body>
</html>
"""

with open(OUT, 'w', encoding='utf-8') as f:
    f.write(HTML)

size_kb = round(os.path.getsize(OUT) / 1024, 1)
print(f"Presentacion generada: {OUT}  ({size_kb} KB)")
print("Abrir con doble clic en Chrome o Edge.")
print("Teclas: -> siguiente | <- anterior | F pantalla completa | ESC vista general")
