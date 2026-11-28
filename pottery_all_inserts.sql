-- =====================================================================
-- Ancient Greek Pots and Myths Catalogue
-- MySQL 8.0 schema (InnoDB, utf8mb4)
-- Dates: BCE stored as negative integers (e.g. -530 = 530 BCE)
--
-- Run AFTER create_pottery_schema.sql, on an empty database.
-- Run the whole file in one session.
--
-- Contents: 12 vessels with 14 Iliad scenes, plus the regions, museums,
-- workshops, artists, elements, media types, characters, archive records,
-- images, and related media they need.
--
-- Sources:
--   Beazley Archive Pottery Database (CARC, Oxford), record URLs in the
--   archive_records section; British Museum and MFA Boston collection
--   pages; Kunsthistorisches Museum and MFA via Google Arts & Culture;
--   National Archaeological Museum Athens (Greek Ministry of Culture);
--   Wikipedia (Francois Vase, Euphronios Krater, Euphorbos plate,
--   Kleitias, Sophilos); Oregon Digital (Lowenstam Collection).
-- From general knowledge, not a source: region coordinates (approximate),
-- element names, related media works, Aryballos shape description.
--
-- NOTE: Descriptions are paraphrased.
--
-- Aligned with the 3NF create_pottery_schema.sql:
--   * stories.literary_source  -> literary_sources + story_sources.passage
--   * characters.alt_spellings -> character_aliases (one row per spelling)
--   * vessels.period_label     -> removed (derive from date_start/date_end)
--   * techniques: section 02 still ALTERs the table to add description,
--     category, dates, kerameikos_uri, source. Those columns are not in the
--     schema file; move them there and delete the ALTER, or this file and
--     the ERD will disagree with the schema.
-- =====================================================================

USE pottery;

-- #####################################################################
-- 01. Shapes
-- #####################################################################

-- =====================================================================
-- Seed data for the shapes table
--
-- Source: Cartwright, M. (2013, May 24). A Visual Glossary of Greek
-- Pottery. World History Encyclopedia.
-- https://www.worldhistory.org/article/489/a-visual-glossary-of-greek-pottery/
--
-- Descriptions are paraphrased summaries. Only vessel shapes are included;
-- function_category falls back to 'other' where the source gives no
-- clear match to the enum (serving, ritual, washing, textile work).
-- =====================================================================


INSERT INTO shapes (name, greek_name, function_category, purpose_description) VALUES

('Alabastron', 'ἀλάβαστρον', 'oil_perfume',
 'Small jar for perfumes, named for the alabaster of the earliest examples. Often carried on a string looped around the neck.'),
('Squat alabastron', NULL, 'oil_perfume',
 'Flat jar for creams and unguents. First seen in Minoan Crete and popular in the Mycenaean period.'),
('Amphora', 'ἀμφορεύς', 'storage',
 'One of the most common Greek shapes, in many forms, always with two vertical neck handles. Stored and transported oil, wine, and foods such as olives. Lids rarely survive.'),
('Neck-amphora', NULL, 'storage',
 'Amphora in which the neck meets the shoulder at a sharp angle.'),
('Askos', 'ἀσκός', 'pouring',
 'Vessel resembling a wineskin. The small neck suggests pouring small quantities of liquids such as fine oil, honey, or vinegar.'),
('Astragalos', 'ἀστράγαλος', 'other',
 'Vessel shaped like a knucklebone. May have held sheep knucklebones used as gaming pieces or dice.'),
('Bell-krater', NULL, 'mixing',
 'Krater with an inverted-bell body, handles set high on the vessel, and a stepped foot.'),
('Calyx-krater', NULL, 'mixing',
 'Krater with a body shaped like a flower calyx, usually with a stepped foot.'),
('Column-krater', NULL, 'mixing',
 'Krater popular in black-figure, with each handle supported by a short vertical column.'),
('Volute-krater', NULL, 'mixing',
 'Krater whose handle tops end in a volute or scroll. More often decorated in red-figure.'),
('Krater', 'κρατήρ', 'mixing',
 'Large two-handled vessel for mixing water and wine, typically at a ratio of 3:1 or 5:3.'),
('Dinos', 'δῖνος', 'mixing',
 'Large round-bottomed bowl without handles, used for mixing wine and water. Usually set on a ceramic stand or metal tripod.'),
('Epinetron', 'ἐπίνητρον', 'other',
 'Half-cylinder worn over the thigh and knee to prepare wool for weaving. The incised upper surface roughened the fibres. Often has a female head at the closed end.'),
('Exaleiptron', 'ἐξάλειπτρον', 'oil_perfume',
 'Usually lidded vessel for fine oil or perfume, with an inverted lip to prevent spills. Vase scenes show it with women bathing and in funerary rites. Also called a kothon.'),
('Figure-of-eight vase', NULL, 'other',
 'Minoan vessel named for its figure-of-eight handle shape.'),
('Fish plate', NULL, 'other',
 'Flat serving dish with a short foot and a central depression for excess oil. Made from the 4th century BCE in Attica and Magna Graecia, usually decorated with fish and sea life.'),
('Hydria', 'ὑδρία', 'storage',
 'Mainly a water-storage vessel and among the commonest Greek shapes. Two horizontal handles for carrying and one vertical handle for pouring. Also used as a child burial container, and made in bronze.'),
('Jug', NULL, 'pouring',
 'Vessel with a spout and a single handle for pouring liquids.'),
('Kantharos', 'κάνθαρος', 'drinking',
 'Cup with two large vertical handles and a stemmed foot.'),
('Kyathos', 'κύαθος', 'pouring',
 'Ladle-like cup used for serving wine.'),
('Kylix', 'κύλιξ', 'drinking',
 'Stemmed wine cup with two horizontal handles. One of the most common Greek shapes, with over 30 varieties.'),
('Lebes gamikos', 'λέβης γαμικός', 'other',
 'Large vase with two upright handles, often with a conical stand and lid. Used in marriage and burial ceremonies.'),
('Lekanis', 'λεκανίς', 'storage',
 'Shallow footed vessel with two horizontal handles and often a single-handled lid. Stored small items, especially for women, and served food, with the inverted lid serving as a second dish.'),
('Lekythos', 'λήκυθος', 'oil_perfume',
 'Vessel for fine oils and perfumes, often dedicated in burials and decorated accordingly, frequently on a white background.'),
('Louterion', 'λουτήριον', 'other',
 'Large two-handled basin, sometimes with a spouted lip. Held washing water, perhaps also for mixing wine and water, and possibly used in funerary rites such as washing the body.'),
('Loutrophoros', 'λουτροφόρος', 'other',
 'Tall slim jar with elongated handles. Held water for wedding and funeral rites and served as a grave marker, especially for the unmarried.'),
('Mastos', 'μαστός', 'drinking',
 'Wine cup shaped like a female breast, with a nipple at the base in place of a foot.'),
('Oinochoe', 'οἰνοχόη', 'pouring',
 'Jug or pitcher for pouring liquids, principally wine.'),
('Pelike', 'πελίκη', 'storage',
 'Jar for storing liquids such as oil and wine. Also used to hold ashes after cremation.'),
('Phiale', 'φιάλη', 'other',
 'Shallow bowl for wine and for pouring libations in religious ceremonies. Often has a raised central knob (omphalos).'),
('Pithos', 'πίθος', 'storage',
 'Large Minoan jar for storing foodstuffs such as grain and olives. Rows of pithoi in storerooms are typical of Minoan palaces.'),
('Plastic vase', NULL, 'other',
 'Vase that incorporates a small sculpture as part of the vessel.'),
('Plate', NULL, 'other',
 'Circular flat dish with a raised rim.'),
('Psykter', 'ψυκτήρ', 'other',
 'Large mushroom-shaped vase used to cool wine. Could stand inside a krater or on its own.'),
('Pyxis', 'πυξίς', 'storage',
 'Small circular lidded box, often used for jewellery and toiletries.'),
('Tripod pyxis', NULL, 'storage',
 'Pyxis on three concave legs. Also called a tripod-kothon.'),
('Rhyton', 'ῥυτόν', 'pouring',
 'Used in religious practice for pouring libations. May take the form of animal heads, especially bulls.'),
('Skyphos', 'σκύφος', 'drinking',
 'Deep two-handled cup or bowl with the handles near the rim.'),
('Stamnos', 'στάμνος', 'mixing',
 'Wide-mouthed jar, often lidded, with two handles. Used for mixing wine and water.'),
('Stemmed cup', NULL, 'drinking',
 'Two-handled drinking cup with stem and base. Popular in Mycenaean culture and the forerunner of the kylix.'),
('Stirrup jar', NULL, 'storage',
 'Appeared on Minoan Crete and became the most common Mycenaean shape. Has a false central spout. Stored wine and oils.');

-- #####################################################################
-- 02. Techniques
-- #####################################################################

-- =====================================================================
-- Seed data for the techniques table
--
-- Sources:
--   1. Kerameikos.org, concept type kon:Technique (22 entries)
--      https://kerameikos.org/browse?q=type%3A%22kon%3ATechnique%22&sort=prefLabel+asc
--      Data under the Open Database License (ODbL): attribution and
--      share-alike apply to derived databases.
--   2. Wikipedia, Greek pottery styles and techniques (15 entries)
--      Text under CC BY-SA 4.0: keep attribution.
--
-- Descriptions are short paraphrases, not copies of source text.
-- Dates are only filled where the source states them; BCE is negative.
-- =====================================================================


-- SCHEMA EXTENSION: these columns are not in create_pottery_schema.sql.
-- If they get added there, delete this ALTER (it will fail on duplicate
-- columns otherwise).
ALTER TABLE techniques
  ADD COLUMN description    TEXT NULL AFTER name,
  ADD COLUMN category       ENUM('technique','style','regional_ware') NOT NULL DEFAULT 'technique' AFTER description,
  ADD COLUMN date_start     SMALLINT NULL AFTER category,
  ADD COLUMN date_end       SMALLINT NULL AFTER date_start,
  ADD COLUMN kerameikos_uri VARCHAR(255) NULL AFTER date_end,
  ADD COLUMN source         VARCHAR(100) NULL AFTER kerameikos_uri,
  ADD UNIQUE KEY uq_techniques_kerameikos (kerameikos_uri);

INSERT INTO techniques (name, description, category, date_start, date_end, kerameikos_uri, source) VALUES

-- ---------------------------------------------------------------------
-- Kerameikos.org
-- ---------------------------------------------------------------------
('Added color',
 'Extra pigments painted onto the vase surface before or after firing. Common on black-figure, red-figure, and white-ground vases. Typical colors are matte white and red/purple, with occasional yellow, greens, blues, pinks, and gilding.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/added_color', 'Kerameikos.org'),
('Added red',
 'Red ochre pigment painted on before firing, giving tints from red to brown and purple. Used for blood, clothing, fillets, borders, and lettering on red-figure vases.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/added_red', 'Kerameikos.org'),
('Added white',
 'White pigment applied, usually before firing. Best known for women''s skin in black-figure and as second white on white-ground vases. Made from materials such as calcareous clay, lead, or perhaps bone.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/added_white', 'Kerameikos.org'),
('Black glaze',
 'Black slip covering the whole vase, also called black gloss or black-painted. It is diluted clay that turns black in firing. Athens led production until about 400 BCE, with South Italy and the Eastern Mediterranean continuing to the 1st century BCE.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/black_glaze', 'Kerameikos.org'),
('Black pattern',
 'Term for Athenian vases without human or animal figures, decorated with floral, linear, or banded patterns. Dated from the mid-6th to the 4th century BCE, with versions from Corinth, Boeotia, Laconia, and South Italy.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/black_pattern', 'Kerameikos.org'),
('Black polychrome',
 'Light-on-dark technique with details in colors such as red and white over black glaze, sometimes with incised ornament. Appears in Athens on the phiale in the late 6th century BCE and is related to Six''s technique.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/black_polychrome', 'Kerameikos.org'),
('Black-figure',
 'Dark-on-light technique: silhouetted figures in clay slip, incised details, sometimes added color, fired in three stages. Invented in Corinth around 700 BCE and used in Athens by about 630 BCE. Regional versions existed in Laconia, Boeotia, East Greece, northern and West Greece, and Etruria.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/black_figure', 'Kerameikos.org'),
('Black-figure white ground',
 'Black-figure figures painted over a white slip. Pioneered by the Edinburgh Painter in the late 6th century BCE, on shapes such as the lekythos, oinochoe, and small neck-amphora.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/black_figure_white_ground', 'Kerameikos.org'),
('Coral red',
 'Intentional red color painted over whole vases in the 6th and 5th centuries BCE, though it adhered poorly. Earliest known example is an Exekias kylix in Munich (BAPD 310403). Mostly on small shapes.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/coral_red', 'Kerameikos.org'),
('Impressed',
 'Designs impressed into the clay before painting, appearing in Athens around the mid-5th century BCE. Small motifs such as rosettes, palmettes, and tongues, usually on drinking vessels.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/impressed', 'Kerameikos.org'),
('Incised',
 'Lines cut into the surface with a sharp tool at the leather-hard stage, mainly for figure details in black-figure and for inscriptions.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/incised', 'Kerameikos.org'),
('Outline',
 'Black slip lines marking the edges of a figure or form, leaving the interior unpainted. Used for anatomical details. Appears in Athens from the Geometric period and later in black-figure, red-figure, and white-ground work.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/outline', 'Kerameikos.org'),
('Plastic',
 'Mold-made figural vessels in human, animal, or hybrid form. Most popular in Athens in the 5th century BCE, also made in Corinth and Boeotia.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/plastic', 'Kerameikos.org'),
('Polychrome',
 'Vases with several colors beyond the usual red and black of fired Athenian clay. Rare in Athens, more common on Corinthian and South Italian wares.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/polychrome', 'Kerameikos.org'),
('Red-figure',
 'Light-on-dark technique: figures left in reserve on the clay surface, with the background painted in slip and details added in gloss and relief lines. Invented in Athens about 530-520 BCE, first used by the Andokides Painter.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/red_figure', 'Kerameikos.org'),
('Relief',
 'Clay added to the surface in Athenian black-figure and red-figure, from small dots for hair to molded figures and applied handle heads. May be highlighted with white or gold.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/relief', 'Kerameikos.org'),
('Reserving',
 'Deliberately leaving a figure or detail unpainted so the fired clay color shows. Used in Athenian black-figure and red-figure, on some Orientalizing vessels, and in East Greek and Boeotian black-figure.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/reserving', 'Kerameikos.org'),
('Semi-outline',
 'Style combining outline and silhouette, applied to single figures or in varying degrees within a scene. Seen on Athenian black-figure eye cups and Little Master cups and on white-ground lekythoi.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/semi-outline', 'Kerameikos.org'),
('Silhouette',
 'Figures or objects painted solid black against a lighter ground. Basis of black-figure before incision, and also found in Geometric, Orientalizing, and red-figure painting.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/silhouette', 'Kerameikos.org'),
('Six''s technique',
 'White, red, or pink silhouette figures on a black surface with incised details. Looks like red-figure but counts as polychrome. Used from about 530 BCE into the early 5th century BCE, mainly on small vessels such as lekythoi. Attributed to the potter Nikosthenes.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/six', 'Kerameikos.org'),
('Stamped',
 'Decoration made with a mold-made terracotta stamp pressed into soft clay before painting. Appears in Athens around the mid-5th century BCE, usually on the interiors of drinking vessels.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/stamped', 'Kerameikos.org'),
('White ground',
 'White clay slip applied before figure decoration. Found on some Geometric and Orientalizing Athenian vessels, then on black-figure from around 530 BCE. After about 480 BCE used mainly for funerary scenes on the lekythos.',
 'technique', NULL, NULL, 'https://kerameikos.org/id/white_ground', 'Kerameikos.org'),

-- ---------------------------------------------------------------------
-- Wikipedia
-- ---------------------------------------------------------------------
('Orientalizing',
 'Style of the 8th and 7th centuries BCE shaped by trade with Asia Minor, Syria, and Phoenicia. Added sphinxes, griffins, lions, and animal friezes, with lotus and palmette ornament. Human figures were rare and usually silhouettes with some incision. Began in Corinth and later developed in Athens.',
 'style', -800, -600, NULL, 'Wikipedia'),
('Proto-Corinthian',
 'Corinthian vase painting that embraced Orientalizing experiments while keeping geometric features. Coexisted with a conservative sub-geometric style. Corinthian wares were exported across Greece.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Proto-Attic',
 'Athenian Orientalizing painting, roughly 725-625 BCE. Orientalizing motifs appear but figures stay unrealistic, favoring Geometric-era scenes such as chariot processions. Painters adopted line drawing in place of silhouette.',
 'regional_ware', -725, -625, NULL, 'Wikipedia'),
('Black-and-white style',
 'Attic style from the mid-7th century BCE with black figures on a white zone, using polychromy for flesh and clothing. Suited the orange Attic clay, which rendered flesh poorly.',
 'style', NULL, NULL, NULL, 'Wikipedia'),
('Wild Goat style',
 'East Greek Orientalizing style, traditionally assigned to Rhodes but found across Asia Minor with production at Miletus and Chios. Superimposed registers of stylized animals, especially wild goats, with filler motifs. Main shapes were oinochoai (copying bronze) and dishes.',
 'style', NULL, NULL, NULL, 'Wikipedia'),
('Bilingual',
 'Vases with one scene in black-figure and the same scene in red-figure on the other side. Introduced around 520 BCE by painters including the Andokides Painter, Oltos, and Psiax.',
 'technique', -520, NULL, NULL, 'Wikipedia'),
('Kerch style',
 'Gilded red-figure of the Black Sea colony of Panticapeum.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Apulian',
 'South Italian red-figure tradition, one of five regional styles. South Italian red-figure added distinctive polychrome painting.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Lucanian',
 'South Italian red-figure tradition, one of five regional styles.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Sicilian',
 'South Italian and Sicilian red-figure tradition, one of five regional styles.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Campanian',
 'South Italian red-figure tradition, one of five regional styles.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Paestan',
 'South Italian red-figure tradition, one of five regional styles. Artists of the late 4th century BCE elsewhere in South Italy, such as the Darius and Underworld Painters, made crowded polychrome scenes.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('West Slope ware',
 'Hellenistic style, mainly eastern Greek, that emerged as black- and red-figure largely disappeared after Alexander the Great.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Centuripe ware',
 'Hellenistic ware from Sicily, emerging as black- and red-figure faded.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia'),
('Gnathia',
 'Hellenistic ware of the western Greek world, emerging as black- and red-figure faded.',
 'regional_ware', NULL, NULL, NULL, 'Wikipedia');

-- #####################################################################
-- 03. Archives
-- #####################################################################

-- =====================================================================
-- Seed data for the archives table
-- license_terms are summaries, not legal text.
-- =====================================================================


INSERT INTO archives (name, base_url, license_terms) VALUES

('Beazley Archive Pottery Database (CARC, University of Oxford)',
 'https://www.carc.ox.ac.uk/carc/pottery',
 'Registration required. Academic and research use only; non-commercial use of images and data for research, teaching, and private study. Oxford CARC asserts copyright on its data and does not own the copyright for most images. Reproduction of text or images is not permitted without permission. Use is logged and monitored. Contact carc@classics.ox.ac.uk before any bulk download or republication.'),

('Corpus Vasorum Antiquorum Online (CVA Online, CARC)',
 'https://www.carc.ox.ac.uk/cva',
 'Hosted by Oxford CARC; same copyright notice and non-commercial research terms as the Beazley Archive apply. Individual CVA fascicule images may belong to the contributing museums. Verify before reuse.'),

('Perseus Digital Library Art and Archaeology Artifact Browser (Tufts University)',
 'https://www.perseus.tufts.edu/hopper/artifactBrowser',
 'Tufts holds overall copyright; materials are offered for personal use by students, scholars, and the public. Some content (texts, and the Art and Archaeology catalog as an open source module) is released under Creative Commons licenses. Check the license on each record and any museum image credits. A newer CollectionBuilder-based browser was released in October 2025, so confirm current URL and terms.'),

('The Digital Archaeological Record (tDAR)',
 'https://core.tdar.org',
 'Terms vary by record. Depositors set access rights (open, embargoed, or restricted) and usage terms. Review each record before scraping or storing its content.'),

('The Metropolitan Museum of Art Open Access Collection',
 'https://www.metmuseum.org/art/collection',
 'Open Access program: images and data for works designated Open Access are available under Creative Commons Zero (CC0) with no permission needed. Check the Open Access flag on each object. The Met also offers a public collection API.');

-- #####################################################################
-- 04. Myths, stories, literary sources (the Iliad only)
-- #####################################################################

-- One myth. Each story is an episode of the Iliad. In the 3NF schema the
-- book reference no longer lives on stories: the work goes in
-- literary_sources and the book goes in story_sources.passage.
-- Only episodes that appear on the vessels (plus Death of Patroclus,
-- used by related_media) are included.

INSERT INTO myths (name) VALUES
('The Iliad');

SET @iliad = (SELECT myth_id FROM myths WHERE name = 'The Iliad');

-- Story map: short keys used by later sections, plus each story's passage.
-- sort_order keeps story_id values in the same order as before.
DROP TABLE IF EXISTS tmp_iliad_story_map;
CREATE TABLE tmp_iliad_story_map (
  story_key   VARCHAR(40)  NOT NULL,
  story_name  VARCHAR(200) NOT NULL,   -- becomes stories.name
  passage     VARCHAR(100) NULL,       -- becomes story_sources.passage (book number)
  sort_order  TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (story_key)
) ENGINE=InnoDB;

INSERT INTO tmp_iliad_story_map (story_key, story_name, passage, sort_order) VALUES
('briseis',         'Briseis Taken from Achilles',       '1',      1),
('embassy',         'Embassy to Achilles',               '9',      2),
('dolon',           'Capture of Dolon',                  '10',     3),
('sarpedon',        'Death of Sarpedon',                 '16',     4),
('death_patroclus', 'Death of Patroclus',                '16',     5),
('euphorbos',       'Fight over the Body of Patroclus',  '17',     6),
('hector_duel',     'Death of Hector',                   '22',     7),
('dragging',        'Dragging of Hector''s Body',        '22-24',  8),
('games',           'Funeral Games of Patroclus',        '23',     9),
('ransom',          'Ransom of Hector',                  '24',    10);

INSERT INTO stories (myth_id, parent_story_id, name)
SELECT @iliad, NULL, sm.story_name
FROM tmp_iliad_story_map sm
ORDER BY sm.sort_order;

INSERT INTO literary_sources (title, author) VALUES
('Iliad', 'Homer');

SET @src_iliad = (SELECT source_id FROM literary_sources WHERE title = 'Iliad' AND author = 'Homer');

INSERT INTO story_sources (story_id, source_id, passage)
SELECT st.story_id, @src_iliad, sm.passage
FROM tmp_iliad_story_map sm
JOIN stories st ON st.name = sm.story_name AND st.myth_id = @iliad;

-- #####################################################################
-- 06. Regions
-- #####################################################################

-- ---------------------------------------------------------------------
-- Parent regions
-- ---------------------------------------------------------------------
INSERT INTO regions (parent_region_id, name, modern_country, latitude, longitude, pleiades_id) VALUES
(NULL, 'Attica',   'Greece', 38.050000, 23.800000, NULL),
(NULL, 'Thessaly', 'Greece', 39.500000, 22.200000, NULL),
(NULL, 'Rhodes',   'Greece', 36.200000, 28.000000, NULL),
(NULL, 'Etruria',  'Italy',  42.700000, 11.800000, NULL),
(NULL, 'Lucania',  'Italy',  40.400000, 16.000000, NULL);

SET @attica   = (SELECT region_id FROM regions WHERE name = 'Attica');
SET @thessaly = (SELECT region_id FROM regions WHERE name = 'Thessaly');
SET @rhodes   = (SELECT region_id FROM regions WHERE name = 'Rhodes');
SET @etruria  = (SELECT region_id FROM regions WHERE name = 'Etruria');
SET @lucania  = (SELECT region_id FROM regions WHERE name = 'Lucania');

-- ---------------------------------------------------------------------
-- Sites
-- ---------------------------------------------------------------------
INSERT INTO regions (parent_region_id, name, modern_country, latitude, longitude, pleiades_id) VALUES
(@attica,   'Athens',       'Greece', 37.971500, 23.725700, NULL),  -- production centre of Attic vases
(@thessaly, 'Pharsalos',    'Greece', 39.295800, 22.384200, NULL),  -- Sophilos fragment
(@rhodes,   'Kameiros',     'Greece', 36.333900, 27.921100, NULL),  -- Euphorbos plate
(@etruria,  'Chiusi',       'Italy',  43.016700, 11.950000, NULL),  -- Francois Vase
(@etruria,  'Cerveteri',    'Italy',  42.000000, 12.100000, NULL),  -- ancient Caere
(@lucania,  'Castelluccio', 'Italy',  40.001100, 15.980600, NULL);  -- Berlin F2176

-- #####################################################################
-- 07. Museums
-- #####################################################################

INSERT INTO museums (name, city, country) VALUES
('Museo Archeologico Nazionale di Firenze',      'Florence',  'Italy'),
('National Archaeological Museum, Athens',       'Athens',    'Greece'),
('Museo Nazionale Archeologico Cerite',          'Cerveteri', 'Italy'),
('Kunsthistorisches Museum',                     'Vienna',    'Austria'),
('British Museum',                               'London',    'United Kingdom'),
('Museum of Fine Arts, Boston',                  'Boston',    'United States'),
('Musée du Louvre',                              'Paris',     'France'),
('Antikensammlung, Staatliche Museen zu Berlin', 'Berlin',    'Germany');

-- #####################################################################
-- 08. Workshops
-- #####################################################################

INSERT INTO workshops (name, notes) VALUES
('Leagros Group',
 'Large group of late Attic black-figure painters, c. 520-500 BCE, named by Beazley after the kalos name Leagros. Known for big hydriai and amphorae with Trojan War scenes. The Antiope Group is a sub-group.'),
('Brygos workshop',
 'Workshop of the potter Brygos in Athens, early 5th century BCE. The Brygos Painter is named after this potter.'),
('Hieron workshop',
 'Workshop of the potter Hieron in Athens, early 5th century BCE. Many of his signed cups were painted by Makron.');

-- #####################################################################
-- 09. Artists
-- #####################################################################

SET @leagros = (SELECT workshop_id FROM workshops WHERE name = 'Leagros Group');
SET @brygos  = (SELECT workshop_id FROM workshops WHERE name = 'Brygos workshop');
SET @hieron  = (SELECT workshop_id FROM workshops WHERE name = 'Hieron workshop');

INSERT INTO artists (workshop_id, name, role, active_start, active_end) VALUES
-- Black-figure
(NULL,     'Kleitias',                 'painter', -570, -560),
(NULL,     'Ergotimos',                'potter',  NULL, NULL),
(NULL,     'Sophilos',                 'both',    -590, -570),
(@leagros, 'Antiope Group',            'painter', NULL, NULL),
-- Red-figure
(NULL,     'Euphronios',               'both',    NULL, NULL),
(NULL,     'Euxitheos',                'potter',  NULL, NULL),
(@brygos,  'Brygos Painter',           'painter', -490, -470),
(NULL,     'Berlin Painter',           'painter', -500, -460),
(@hieron,  'Makron',                   'painter', NULL, NULL),
(@hieron,  'Hieron',                   'potter',  NULL, NULL),
(NULL,     'Eucharides Painter',       'painter', NULL, NULL),
(NULL,     'Painter of Florence 3984', 'painter', NULL, NULL),
(NULL,     'Clinic Painter',           'painter', NULL, NULL),
-- South Italian (Lucanian) red-figure
(NULL,     'Dolon Painter',            'painter', NULL, NULL);

-- #####################################################################
-- 10. Elements
-- #####################################################################

INSERT INTO elements (name, category) VALUES

-- ---------------------------------------------------------------------
-- Objects
-- ---------------------------------------------------------------------
('chariot',            'object'),
('tripod',             'object'),
('prize cauldron',     'object'),
('corpse',             'object'),
('shield',             'object'),
('spear',              'object'),
('sword',              'object'),
('bow',                'object'),
('quiver',             'object'),
('helmet',             'object'),
('kline',              'object'),
('table with meat',    'object'),
('ransom gifts',       'object'),
('suspended armor',    'object'),
('herald''s staff',    'object'),
('stool',              'object'),
('wolf skin',          'object'),
('eidolon',            'object'),
('snake',              'object'),

-- ---------------------------------------------------------------------
-- Actions
-- ---------------------------------------------------------------------
('chariot race',       'action'),
('duel',               'action'),
('carrying the dead',  'action'),
('dragging the corpse','action'),
('mourning',           'action'),
('leading by the wrist','action'),
('persuasion scene',   'action'),
('ambush and capture', 'action'),

-- ---------------------------------------------------------------------
-- Inscriptions
-- ---------------------------------------------------------------------
('name inscription',   'inscription'),
('artist signature',   'inscription'),
('scene label',        'inscription'),

-- ---------------------------------------------------------------------
-- Settings
-- ---------------------------------------------------------------------
('grandstand',         'setting'),
('turning post',       'setting'),
('tomb mound',         'setting'),
('city gate or palace','setting'),
('tent',               'setting'),
('tree',               'setting');

-- #####################################################################
-- 11. Media types
-- #####################################################################

INSERT INTO media_types (name) VALUES
('film'),
('opera'),
('painting'),
('novel'),
('game');

-- #####################################################################
-- 12. Characters and aliases (add-if-missing) and character map
-- #####################################################################

-- In the 3NF schema, alternate spellings moved from characters.alt_spellings
-- (a multi-valued column) to one row per spelling in character_aliases.

DROP TEMPORARY TABLE IF EXISTS stage_characters;
CREATE TEMPORARY TABLE stage_characters (
  name  VARCHAR(120) NOT NULL,
  type  VARCHAR(60)  NULL,
  side  VARCHAR(10)  NOT NULL
);

INSERT INTO stage_characters (name, type, side) VALUES
-- Greeks
('Achilles',   'hero',   'greek'),
('Patroclus',  'hero',   'greek'),
('Agamemnon',  'hero',   'greek'),
('Menelaus',   'hero',   'greek'),
('Odysseus',   'hero',   'greek'),
('Diomedes',   'hero',   'greek'),
('Ajax',       'hero',   'greek'),
('Phoenix',    'mortal', 'greek'),
('Talthybius', 'mortal', 'greek'),
('Automedon',  'mortal', 'greek'),
('Briseis',    'mortal', 'other'),
-- Trojans and allies
('Hector',     'hero',   'trojan'),
('Priam',      'mortal', 'trojan'),
('Hecuba',     'mortal', 'trojan'),
('Sarpedon',   'hero',   'trojan'),
('Euphorbus',  'hero',   'trojan'),
('Dolon',      'mortal', 'trojan'),
-- Gods and personifications
('Athena',     'god',    'divine'),
('Apollo',     'god',    'divine'),
('Hermes',     'god',    'divine'),
('Iris',       'god',    'divine'),
('Hypnos',     'god',    'divine'),
('Thanatos',   'god',    'divine');

-- One row per alternate spelling (was the semicolon list in alt_spellings).
-- language: greek = transliteration of the Greek form, latin = Latin form,
-- english = English translation or epithet, NULL = variant/misspelling
-- whose origin is not recorded.
DROP TEMPORARY TABLE IF EXISTS stage_character_aliases;
CREATE TEMPORARY TABLE stage_character_aliases (
  character_name  VARCHAR(120) NOT NULL,   -- must match stage_characters.name
  alias           VARCHAR(120) NOT NULL,
  language        VARCHAR(40)  NULL
);

INSERT INTO stage_character_aliases (character_name, alias, language) VALUES
('Achilles',   'Achilleus',       'greek'),
('Achilles',   'Achiles',         NULL),
('Patroclus',  'Patroklos',       'greek'),
('Patroclus',  'Patroklus',       NULL),
('Agamemnon',  'Agamemmon',       NULL),
('Menelaus',   'Menelaos',        'greek'),
('Menelaus',   'Menelas',         NULL),
('Odysseus',   'Olytteus',        'greek'),
('Odysseus',   'Olyteus',         'greek'),
('Odysseus',   'Ulysses',         'latin'),
('Diomedes',   'Diomede',         NULL),
('Ajax',       'Aias',            'greek'),
('Ajax',       'Telamonian Ajax', 'english'),
('Phoenix',    'Phoinix',         'greek'),
('Talthybius', 'Talthybios',      'greek'),
('Hector',     'Hektor',          'greek'),
('Priam',      'Priamos',         'greek'),
('Hecuba',     'Hekabe',          'greek'),
('Hecuba',     'Hecabe',          NULL),
('Euphorbus',  'Euphorbos',       'greek'),
('Athena',     'Athene',          'greek'),
('Athena',     'Athenaia',        'greek'),
('Apollo',     'Apollon',         'greek'),
('Hypnos',     'Sleep',           'english'),
('Thanatos',   'Death',           'english');

-- Insert only characters that don't already exist under any spelling:
-- not as a name, not as an existing alias, and none of their staged
-- aliases is already a character name.
INSERT INTO characters (name, type, side)
SELECT s.name, s.type, s.side
FROM stage_characters s
WHERE NOT EXISTS (SELECT 1 FROM characters c WHERE c.name = s.name)
  AND NOT EXISTS (SELECT 1 FROM character_aliases a WHERE a.alias = s.name)
  AND NOT EXISTS (SELECT 1 FROM characters c2
                  JOIN stage_character_aliases sa ON sa.alias = c2.name
                  WHERE sa.character_name = s.name);

-- Build the lookup map used by later sections:
-- exact name first, then existing alias, then staged alias matching a name.
DROP TABLE IF EXISTS tmp_iliad_character_map;
CREATE TABLE tmp_iliad_character_map AS
SELECT s.name AS char_key,
       COALESCE(
         (SELECT c.character_id FROM characters c
          WHERE c.name = s.name ORDER BY c.character_id LIMIT 1),
         (SELECT a.character_id FROM character_aliases a
          WHERE a.alias = s.name ORDER BY a.character_id LIMIT 1),
         (SELECT c2.character_id FROM characters c2
          JOIN stage_character_aliases sa ON sa.alias = c2.name
          WHERE sa.character_name = s.name ORDER BY c2.character_id LIMIT 1)
       ) AS character_id
FROM stage_characters s;

-- Add the aliases. A spelling a character already has is skipped
-- (uq_alias on character_id, alias); the canonical name itself is not
-- stored as an alias.
INSERT INTO character_aliases (character_id, alias, language)
SELECT m.character_id, sa.alias, sa.language
FROM stage_character_aliases sa
JOIN tmp_iliad_character_map m ON m.char_key = sa.character_name
JOIN characters c ON c.character_id = m.character_id
WHERE sa.alias <> c.name
ON DUPLICATE KEY UPDATE alias = character_aliases.alias;

-- #####################################################################
-- 13. Vessels
-- #####################################################################

-- Shape needed by one vessel but missing from shapes_inserts.sql
-- (general knowledge, not from the Cartwright glossary; verify)
INSERT INTO shapes (name, greek_name, function_category, purpose_description) VALUES
('Aryballos', 'ἀρύβαλλος', 'oil_perfume',
 'Small round flask with a narrow neck for oil, often carried by athletes.');

-- Lookups
SET @volute    = (SELECT shape_id FROM shapes WHERE name = 'Volute-krater');
SET @calyx     = (SELECT shape_id FROM shapes WHERE name = 'Calyx-krater');
SET @dinos     = (SELECT shape_id FROM shapes WHERE name = 'Dinos');
SET @skyphos   = (SELECT shape_id FROM shapes WHERE name = 'Skyphos');
SET @hydria    = (SELECT shape_id FROM shapes WHERE name = 'Hydria');
SET @aryballos = (SELECT shape_id FROM shapes WHERE name = 'Aryballos');
SET @plate     = (SELECT shape_id FROM shapes WHERE name = 'Plate');

SET @bf        = (SELECT technique_id FROM techniques WHERE name = 'Black-figure');
SET @rf        = (SELECT technique_id FROM techniques WHERE name = 'Red-figure');
SET @wildgoat  = (SELECT technique_id FROM techniques WHERE name = 'Wild Goat style');

SET @athens    = (SELECT region_id FROM regions WHERE name = 'Athens');
SET @pharsalos = (SELECT region_id FROM regions WHERE name = 'Pharsalos');
SET @kameiros  = (SELECT region_id FROM regions WHERE name = 'Kameiros');
SET @chiusi    = (SELECT region_id FROM regions WHERE name = 'Chiusi');
SET @cerveteri = (SELECT region_id FROM regions WHERE name = 'Cerveteri');
SET @castell   = (SELECT region_id FROM regions WHERE name = 'Castelluccio');
SET @rhodes    = (SELECT region_id FROM regions WHERE name = 'Rhodes');
SET @lucania   = (SELECT region_id FROM regions WHERE name = 'Lucania');

SET @m_florence = (SELECT museum_id FROM museums WHERE name = 'Museo Archeologico Nazionale di Firenze');
SET @m_athens   = (SELECT museum_id FROM museums WHERE name = 'National Archaeological Museum, Athens');
SET @m_cerite   = (SELECT museum_id FROM museums WHERE name = 'Museo Nazionale Archeologico Cerite');
SET @m_vienna   = (SELECT museum_id FROM museums WHERE name = 'Kunsthistorisches Museum');
SET @m_bm       = (SELECT museum_id FROM museums WHERE name = 'British Museum');
SET @m_boston   = (SELECT museum_id FROM museums WHERE name = 'Museum of Fine Arts, Boston');
SET @m_louvre   = (SELECT museum_id FROM museums WHERE name = 'Musée du Louvre');
SET @m_berlin   = (SELECT museum_id FROM museums WHERE name = 'Antikensammlung, Staatliche Museen zu Berlin');

INSERT INTO vessels (shape_id, technique_id, findspot_region_id, production_region_id,
                     findspot_certainty, production_certainty, museum_id, accession_number,
                     vessel_name, date_start, date_end, dating_basis,
                     vessel_description, review_status) VALUES

-- ---------------------------------------------------------------------
-- Attic black-figure
-- ---------------------------------------------------------------------
(@volute, @bf, @chiusi, @athens, 'certain', 'certain', @m_florence, '4209',
 'François Vase', -570, -560,
 'Signatures of Kleitias and Ergotimos; dated c. 570-560 BCE by style',
 'Large Attic volute-krater with about 270 figures, many named by inscription. Signed by Ergotimos as potter and Kleitias as painter. Found in 1844 in an Etruscan tomb at Fonte Rotella near Chiusi. Iliad scene: the chariot race at the funeral games of Patroklos (neck, side A). Other friezes (Kalydonian boar hunt, wedding of Peleus and Thetis, ambush of Troilos, pygmies and cranes) are outside the Iliad.',
 'unreviewed'),

(@dinos, @bf, @pharsalos, @athens, 'certain', 'certain', @m_athens, '15499',
 'Sophilos Dinos Fragment (Games of Patroklos)', -580, -570,
 'Signature of Sophilos; museum date c. 580-570 BCE',
 'Fragment of an Attic dinos (some sources call it a lebes) signed by Sophilos as both painter and potter, the earliest Attic painter known by name. Found at Palaiokastro near Pharsalos in Thessaly. A painted label names the scene as the games for Patroklos and names Achilles. Spectators sit on a grandstand. Lower friezes are animal friezes.',
 'unreviewed'),

(@hydria, @bf, NULL, @athens, 'unknown', 'certain', @m_boston, '63.473',
 'Boston Hydria (Dragging of Hektor)', -520, -510,
 'Museum date about 520-510 BCE; attribution to the Antiope Group (Leagros Group)',
 'Attic hydria. On the body, Achilles mounts his chariot and drags the body of Hektor around the tomb of Patroklos, whose armed soul rises above it. Priam and Hecuba watch from a building at left, and the winged Iris arrives. Hektor and Patroklos are named. Shoulder: Herakles fighting Kyknos (not Iliad). Findspot not recorded.',
 'unreviewed'),

-- ---------------------------------------------------------------------
-- Attic red-figure
-- ---------------------------------------------------------------------
(@calyx, @rf, @cerveteri, @athens, 'probable', 'certain', @m_cerite, NULL,
 'Euphronios Krater (Sarpedon Krater)', -520, -510,
 'Signatures of Euphronios (painter) and Euxitheos (potter); c. 515 BCE',
 'Attic calyx-krater signed by Euphronios as painter and Euxitheos as potter. Looted from an Etruscan tomb near Cerveteri in 1971 (per Italian court records), held by the Metropolitan Museum (1972.11.10) until returned to Italy in 2008, then shown at Villa Giulia (L.2006.10) before moving to Cerveteri. Side A: Hypnos and Thanatos lift the body of Sarpedon while Hermes watches; all named. Side B: youths arming (not Iliad). Current accession number not confirmed.',
 'unreviewed'),

(@skyphos, @rf, @cerveteri, @athens, 'certain', 'certain', @m_vienna, 'IV 3710',
 'Brygos Painter Skyphos (Ransom of Hektor)', -490, -480,
 'Attribution to the Brygos Painter; museum date c. 490 BCE',
 'Large Attic skyphos from a tomb at Cerveteri. Side A: Achilles reclines on a couch in his tent with a table of meat while Hektor''s body lies beneath; Priam approaches with servants carrying the ransom. Side B: seated heroes and draped men (not a specific Iliad scene).',
 'unreviewed'),

(@volute, @rf, @cerveteri, @athens, 'certain', 'certain', @m_bm, '1848,0801.1',
 'Berlin Painter Volute-Krater (Achilles and Hektor)', -490, -460,
 'British Museum date 490-460 BCE (CAVI gives c. 490); attribution to the Berlin Painter',
 'Attic volute-krater (old number E468) found at Cerveteri. Figure scenes are confined to narrow neck friezes. Neck B: Achilles strikes the wounded Hektor while Athena urges him on and Apollo turns away; all named. Neck A: Achilles and Memnon between Thetis and Eos (Aethiopis, not Iliad).',
 'unreviewed'),

(@skyphos, @rf, NULL, @athens, 'unknown', 'certain', @m_louvre, 'G146',
 'Makron Skyphos (Briseis and the Embassy)', -490, -480,
 'Attribution to Makron; CAVI date 490-480 BCE',
 'Attic skyphos signed by Hieron as potter and attributed to Makron. Fragments once in Malibu and Berlin have been joined to it. Side A: Agamemnon leads Briseis away, with Talthybios and Diomedes. Side B: the embassy to Achilles, with Ajax, Odysseus and Phoinix. Most figures named. Findspot not recorded.',
 'unreviewed'),

(@calyx, @rf, @cerveteri, @athens, 'certain', 'certain', @m_louvre, 'G163',
 'Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', -500, -480,
 'Attribution to the Eucharides Painter; CAVI date early 5th century BCE',
 'Attic calyx-krater from Cerveteri, partly fragmentary. Side A: Hypnos and Thanatos (named) carry the body of Sarpedon. Side B: the embassy to Achilles, with Achilles and Odysseus seated; Phoinix and Ajax identified only tentatively. Lower frieze: satyrs and komos (not Iliad).',
 'unreviewed'),

(@hydria, @rf, @castell, @athens, 'certain', 'certain', @m_berlin, 'F2176',
 'Berlin Hydria F2176 (Embassy to Achilles)', -500, -475,
 'CAVI: first quarter of 5th century BCE; attribution perhaps to the Painter of Florence 3984',
 'Attic hydria found at Castelluccio in Basilicata. Shoulder: the embassy to Achilles, with Phoinix, Odysseus and Achilles all seated and a helmet hanging above. The inscriptions are nonsense letters, so the figures are identified from the composition. Attribution marked "perhaps" by Beazley.',
 'unreviewed'),

(@aryballos, @rf, @athens, @athens, 'probable', 'certain', @m_berlin, 'F2326',
 'Clinic Painter Aryballos (Embassy to Achilles)', -475, -465,
 'Attribution to the Clinic Painter, a follower of Makron; CAVI date c. 470 BCE',
 'Small Attic aryballos said to be from Athens. Body: the embassy to Achilles, with Odysseus, Ajax, Phoinix and Diomedes (all named, some misspelled); a shield hangs above. Shoulder: dogs.',
 'unreviewed'),

-- ---------------------------------------------------------------------
-- East Greek (Orientalizing)
-- ---------------------------------------------------------------------
(@plate, @wildgoat, @kameiros, @rhodes, 'certain', 'probable', @m_bm, '1860,0404.1',
 'Euphorbos Plate', -610, -590,
 'Style (Middle Wild Goat), c. 600 BCE',
 'East Greek plate in the Wild Goat style, found at Kameiros on Rhodes in 1859-60. Menelaos and Hektor fight over the fallen Euphorbos; all three are named, the earliest writing on a vase from Kameiros. The pairing differs slightly from Iliad 17, where Hektor arrives after Menelaos kills Euphorbos.',
 'unreviewed'),

-- ---------------------------------------------------------------------
-- South Italian (Lucanian) red-figure
-- ---------------------------------------------------------------------
(@calyx, @rf, NULL, @lucania, 'unknown', 'probable', @m_bm, '1846,0925.3',
 'Dolon Painter Calyx-Krater', -390, -380,
 'British Museum date c. 390-380 BCE; Trendall, Red-figured Vases of Lucania, Campania and Sicily, no. 533',
 'Lucanian calyx-krater (old number F157) that gives the Dolon Painter his name. Side A: Odysseus and Diomedes seize the Trojan spy Dolon, who wears a spotted skin and carries a bow, between two trees. Side B: women offering wreaths to youths (not Iliad). Findspot not recorded.',
 'unreviewed');

-- #####################################################################
-- 14. Archive records
-- #####################################################################

SET @beazley = (SELECT archive_id FROM archives
                WHERE name = 'Beazley Archive Pottery Database (CARC, University of Oxford)');

INSERT INTO archive_records (vessel_id, archive_id, external_record_id, url, raw_source_text, date_scraped) VALUES

((SELECT vessel_id FROM vessels WHERE vessel_name = 'François Vase'),
 @beazley, '300000', 'https://www.carc.ox.ac.uk/record/35ACBA5B-7FF1-4572-BA34-6AC260F62A33', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Sophilos Dinos Fragment (Games of Patroklos)'),
 @beazley, '305075', 'https://www.carc.ox.ac.uk/record/DC9EC2C0-5643-4D2B-B58F-987CAFC23997', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Boston Hydria (Dragging of Hektor)'),
 @beazley, '351200', 'https://www.carc.ox.ac.uk/record/7351CB38-579B-4F06-9988-A7C652C9760E', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Euphronios Krater (Sarpedon Krater)'),
 @beazley, '187', 'https://www.carc.ox.ac.uk/record/2F320D8E-61D8-4965-A2C5-C2E76A149354', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Brygos Painter Skyphos (Ransom of Hektor)'),
 @beazley, '204068', 'https://www.carc.ox.ac.uk/record/400B8544-4BC3-4F83-B390-76946059DF48', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Berlin Painter Volute-Krater (Achilles and Hektor)'),
 @beazley, '201941', 'https://www.carc.ox.ac.uk/record/6827863E-3495-493D-9AFB-80952FBBD3D9', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Makron Skyphos (Briseis and the Embassy)'),
 @beazley, '204682', 'https://www.carc.ox.ac.uk/record/E027CEA5-C3B9-4140-A97A-F97919D74FF3', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)'),
 @beazley, '202217', 'https://www.carc.ox.ac.uk/record/FEDD158E-F0CF-45E2-A811-284D14FDF30B', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Berlin Hydria F2176 (Embassy to Achilles)'),
 @beazley, '202832', 'https://www.carc.ox.ac.uk/record/AC671025-2733-4E8D-8126-347ECB8A5D87', NULL, '2026-11-21'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Clinic Painter Aryballos (Embassy to Achilles)'),
 @beazley, '210079', 'https://www.carc.ox.ac.uk/record/1A9A0B4B-4CE4-4CB6-9A86-2E0A5E67CD25', NULL, '2026-11-21');

-- #####################################################################
-- 15. Vessel artists
-- #####################################################################

DROP TEMPORARY TABLE IF EXISTS stage_vessel_artists;
CREATE TEMPORARY TABLE stage_vessel_artists (
  vessel_name       VARCHAR(200) NOT NULL,
  artist_name       VARCHAR(150) NOT NULL,
  attribution_type  VARCHAR(20)  NOT NULL
);

INSERT INTO stage_vessel_artists (vessel_name, artist_name, attribution_type) VALUES
('François Vase',                                              'Kleitias',                 'signed'),
('François Vase',                                              'Ergotimos',                'signed'),
('Sophilos Dinos Fragment (Games of Patroklos)',               'Sophilos',                 'signed'),
('Boston Hydria (Dragging of Hektor)',                         'Antiope Group',            'attributed'),
('Euphronios Krater (Sarpedon Krater)',                        'Euphronios',               'signed'),
('Euphronios Krater (Sarpedon Krater)',                        'Euxitheos',                'signed'),
('Brygos Painter Skyphos (Ransom of Hektor)',                  'Brygos Painter',           'attributed'),
('Berlin Painter Volute-Krater (Achilles and Hektor)',         'Berlin Painter',           'attributed'),
('Makron Skyphos (Briseis and the Embassy)',                   'Makron',                   'attributed'),
('Makron Skyphos (Briseis and the Embassy)',                   'Hieron',                   'signed'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'Eucharides Painter',       'attributed'),
('Berlin Hydria F2176 (Embassy to Achilles)',                  'Painter of Florence 3984', 'attributed'),
('Clinic Painter Aryballos (Embassy to Achilles)',             'Clinic Painter',           'attributed'),
('Clinic Painter Aryballos (Embassy to Achilles)',             'Makron',                   'circle_of'),
('Dolon Painter Calyx-Krater',                                 'Dolon Painter',            'attributed');

INSERT INTO vessel_artists (vessel_id, artist_id, attribution_type)
SELECT v.vessel_id, a.artist_id, s.attribution_type
FROM stage_vessel_artists s
JOIN vessels v ON v.vessel_name = s.vessel_name
JOIN artists a ON a.name = s.artist_name;

-- #####################################################################
-- 16. Depictions
-- #####################################################################

-- Story lookups
SET @s_briseis   = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'briseis'     ORDER BY st.story_id LIMIT 1);
SET @s_embassy   = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'embassy'     ORDER BY st.story_id LIMIT 1);
SET @s_dolon     = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'dolon'       ORDER BY st.story_id LIMIT 1);
SET @s_sarpedon  = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'sarpedon'    ORDER BY st.story_id LIMIT 1);
SET @s_euphorbos = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'euphorbos'   ORDER BY st.story_id LIMIT 1);
SET @s_duel      = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'hector_duel' ORDER BY st.story_id LIMIT 1);
SET @s_dragging  = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'dragging'    ORDER BY st.story_id LIMIT 1);
SET @s_games     = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'games'       ORDER BY st.story_id LIMIT 1);
SET @s_ransom    = (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name WHERE sm.story_key = 'ransom'      ORDER BY st.story_id LIMIT 1);

-- Vessel lookups
SET @v_francois  = (SELECT vessel_id FROM vessels WHERE vessel_name = 'François Vase');
SET @v_sophilos  = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Sophilos Dinos Fragment (Games of Patroklos)');
SET @v_boston    = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Boston Hydria (Dragging of Hektor)');
SET @v_euphron   = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Euphronios Krater (Sarpedon Krater)');
SET @v_brygos    = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Brygos Painter Skyphos (Ransom of Hektor)');
SET @v_e468      = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Berlin Painter Volute-Krater (Achilles and Hektor)');
SET @v_makron    = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Makron Skyphos (Briseis and the Embassy)');
SET @v_euchar    = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)');
SET @v_f2176     = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Berlin Hydria F2176 (Embassy to Achilles)');
SET @v_clinic    = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Clinic Painter Aryballos (Embassy to Achilles)');
SET @v_euphorbos = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Euphorbos Plate');
SET @v_dolon     = (SELECT vessel_id FROM vessels WHERE vessel_name = 'Dolon Painter Calyx-Krater');

INSERT INTO depictions (vessel_id, story_id, location_on_vessel, moment_depicted, description,
                        notes, raw_source_text, extraction_method, confidence, review_status) VALUES

-- ---------------------------------------------------------------------
-- Iliad 1: Briseis taken from Achilles
-- ---------------------------------------------------------------------
(@v_makron, @s_briseis, 'side_a',
 'Agamemnon leads Briseis away by the wrist',
 'Agamemnon leads Briseis to the left. The herald Talthybios, with his staff, and Diomedes follow; Diomedes looks back. A tree marks the setting.',
 'Briseis is not named on the vase; the men are.', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 9: Embassy to Achilles
-- ---------------------------------------------------------------------
(@v_makron, @s_embassy, 'side_b',
 'Ajax, Odysseus and Phoinix appeal to the seated Achilles',
 'Ajax leans on a stick and Odysseus, armed, leans on two spears; Achilles sits facing them with Phoinix behind him. A cushioned stool sits under the handle.',
 NULL, NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

(@v_euchar, @s_embassy, 'side_b',
 'Achilles and Odysseus seated in conversation',
 'Achilles and Odysseus sit facing each other, with a sword and shield hanging above and a leopard skin on a stool. Two standing men are probably Phoinix and Ajax.',
 'Phoinix and Ajax identified tentatively in the Beazley record.', NULL, 'claude_manual_curation', 0.80, 'unreviewed'),

(@v_f2176, @s_embassy, 'shoulder',
 'Phoinix, Odysseus and Achilles seated',
 'Three seated men, Phoinix, Odysseus and Achilles, with a helmet hanging above.',
 'Inscriptions are nonsense letters; identification from composition.', NULL, 'claude_manual_curation', 0.85, 'unreviewed'),

(@v_clinic, @s_embassy, 'other',
 'Odysseus, Ajax, Phoinix and Diomedes visit Achilles',
 'Draped figures, some seated, with a shield hanging above. Odysseus, Ajax, Phoinix, Diomedes and Achilles are named, several with unusual spellings.',
 'Location is the body of the aryballos (enum has no body value).', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 10: Dolon
-- ---------------------------------------------------------------------
(@v_dolon, @s_dolon, 'side_a',
 'Odysseus and Diomedes seize Dolon',
 'Dolon crouches in surprise between two trees, wearing a spotted skin and fur cap, bow in one hand and spear in the other. Odysseus, sword drawn, reaches for his shoulder while Diomedes grabs him from the other side.',
 'No inscriptions; Dolon identified by costume.', NULL, 'claude_manual_curation', 0.90, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 16: Death of Sarpedon
-- ---------------------------------------------------------------------
(@v_euphron, @s_sarpedon, 'side_a',
 'Hypnos and Thanatos lift the body of Sarpedon',
 'The winged brothers Sleep and Death lift the bleeding body of Sarpedon from the battlefield while Hermes directs them. Two warriors stand at the sides. Every figure is named.',
 'The flanking warriors are named Laodamas and Hippolytos.', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

(@v_euchar, @s_sarpedon, 'side_a',
 'Hypnos and Thanatos carry the body of Sarpedon',
 'Sleep and Death carry the body of Sarpedon. The scene is fragmentary.',
 'Odysseus and Diomedes are also named on side A; their role is unclear, so they are not linked as characters.', NULL, 'claude_manual_curation', 0.90, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 17: Fight over the body of Patroklos (Euphorbos)
-- ---------------------------------------------------------------------
(@v_euphorbos, @s_euphorbos, 'interior',
 'Menelaos and Hektor fight over the fallen Euphorbos',
 'Two warriors face each other in combat over the body of a third. All three are named in archaic letters.',
 'Some scholars note Menelaos and Hektor never actually fight over Euphorbos in the Iliad; the labels give a generic duel a Homeric meaning.', NULL, 'claude_manual_curation', 0.90, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 22: Death of Hektor
-- ---------------------------------------------------------------------
(@v_e468, @s_duel, 'neck',
 'Achilles delivers the final blow to Hektor',
 'Achilles presses forward with his spear as Hektor, wounded in the chest and thigh, sinks backward. Athena stands behind Achilles urging him on; Apollo walks away, abandoning Hektor. All named.',
 'Neck, side B. Neck side A (Achilles and Memnon) is not Iliad.', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 22-24: Dragging of Hektor's body
-- ---------------------------------------------------------------------
(@v_boston, @s_dragging, 'side_a',
 'Achilles drags Hektor around the tomb of Patroklos',
 'Achilles steps into his chariot with Hektor''s body tied behind. At left, Priam and Hecuba grieve in a building; at right, the armed soul of Patroklos rises from his tomb, with a snake in front. The winged Iris arrives to stop the abuse.',
 'Several moments of the story are combined in one picture.', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 23: Funeral games of Patroklos
-- ---------------------------------------------------------------------
(@v_francois, @s_games, 'neck',
 'Chariot race at the funeral games, Achilles at the turning post',
 'Four-horse chariots race toward Achilles, who stands at the finish. Tripods and a cauldron are shown as prizes. Charioteers and Achilles are named.',
 'Neck, side A. Kleitias names the racers differently from Homer''s list in Iliad 23.', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

(@v_sophilos, @s_games, 'other',
 'Chariot race watched from a grandstand',
 'Racing horses approach a wooden grandstand filled with seated spectators. A painted label names the games of Patroklos; Achilles is named.',
 'Location is the top body frieze of the dinos (enum has no body value).', NULL, 'claude_manual_curation', 0.95, 'unreviewed'),

-- ---------------------------------------------------------------------
-- Iliad 24: Ransom of Hektor
-- ---------------------------------------------------------------------
(@v_brygos, @s_ransom, 'side_a',
 'Priam comes to Achilles'' tent to ransom Hektor''s body',
 'Achilles reclines on a couch eating, with a table of meat before him and Hektor''s bloodied body on the ground beneath. Priam approaches unnoticed, followed by attendants carrying vessels and boxes as ransom. Armor hangs on the tent wall.',
 'Figures identified by scholars; no inscriptions recorded.', NULL, 'claude_manual_curation', 0.90, 'unreviewed');

-- #####################################################################
-- 17. Depiction characters
-- #####################################################################

DROP TEMPORARY TABLE IF EXISTS stage_depiction_characters;
CREATE TEMPORARY TABLE stage_depiction_characters (
  vessel_name     VARCHAR(200) NOT NULL,
  location        VARCHAR(20)  NOT NULL,
  character_name  VARCHAR(120) NOT NULL,
  role            VARCHAR(20)  NOT NULL,
  identified_by   VARCHAR(20)  NOT NULL
);

INSERT INTO stage_depiction_characters (vessel_name, location, character_name, role, identified_by) VALUES

-- Briseis taken (Makron, side A)
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'Agamemnon',  'central',   'inscription'),
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'Briseis',    'central',   'scholarly'),
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'Talthybius', 'secondary', 'inscription'),
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'Diomedes',   'secondary', 'inscription'),

-- Embassy (Makron, side B)
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'Achilles',   'central',   'inscription'),
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'Odysseus',   'secondary', 'inscription'),
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'Ajax',       'secondary', 'inscription'),
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'Phoenix',    'secondary', 'inscription'),

-- Embassy (Eucharides Painter, side B)
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'Achilles', 'central',    'scholarly'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'Odysseus', 'secondary',  'scholarly'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'Phoenix',  'background', 'scholarly'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'Ajax',     'background', 'scholarly'),

-- Embassy (Berlin F2176, shoulder)
('Berlin Hydria F2176 (Embassy to Achilles)', 'shoulder', 'Achilles', 'central',   'scholarly'),
('Berlin Hydria F2176 (Embassy to Achilles)', 'shoulder', 'Odysseus', 'secondary', 'scholarly'),
('Berlin Hydria F2176 (Embassy to Achilles)', 'shoulder', 'Phoenix',  'secondary', 'scholarly'),

-- Embassy (Clinic Painter aryballos)
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'Achilles', 'central',   'inscription'),
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'Odysseus', 'secondary', 'inscription'),
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'Ajax',     'secondary', 'inscription'),
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'Phoenix',  'secondary', 'inscription'),
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'Diomedes', 'secondary', 'inscription'),

-- Dolon
('Dolon Painter Calyx-Krater', 'side_a', 'Dolon',    'central', 'attributes'),
('Dolon Painter Calyx-Krater', 'side_a', 'Odysseus', 'central', 'scholarly'),
('Dolon Painter Calyx-Krater', 'side_a', 'Diomedes', 'central', 'scholarly'),

-- Sarpedon (Euphronios)
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'Sarpedon', 'central',   'inscription'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'Hypnos',   'central',   'inscription'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'Thanatos', 'central',   'inscription'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'Hermes',   'secondary', 'inscription'),

-- Sarpedon (Eucharides Painter)
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_a', 'Sarpedon', 'central', 'inscription'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_a', 'Hypnos',   'central', 'inscription'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_a', 'Thanatos', 'central', 'inscription'),

-- Euphorbos plate
('Euphorbos Plate', 'interior', 'Menelaus',  'central',   'inscription'),
('Euphorbos Plate', 'interior', 'Hector',    'central',   'inscription'),
('Euphorbos Plate', 'interior', 'Euphorbus', 'secondary', 'inscription'),

-- Death of Hektor (Berlin Painter)
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'Achilles', 'central',   'inscription'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'Hector',   'central',   'inscription'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'Athena',   'secondary', 'inscription'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'Apollo',   'secondary', 'inscription'),

-- Dragging of Hektor (Boston)
('Boston Hydria (Dragging of Hektor)', 'side_a', 'Achilles',  'central',    'scholarly'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'Hector',    'central',    'inscription'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'Patroclus', 'secondary',  'inscription'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'Priam',     'secondary',  'scholarly'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'Hecuba',    'secondary',  'scholarly'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'Iris',      'background', 'attributes'),

-- Funeral games (Francois Vase)
('François Vase', 'neck', 'Achilles',  'central',   'inscription'),
('François Vase', 'neck', 'Diomedes',  'secondary', 'inscription'),
('François Vase', 'neck', 'Odysseus',  'secondary', 'inscription'),
('François Vase', 'neck', 'Automedon', 'secondary', 'inscription'),

-- Funeral games (Sophilos)
('Sophilos Dinos Fragment (Games of Patroklos)', 'other', 'Achilles', 'central', 'inscription'),

-- Ransom of Hektor (Brygos Painter)
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'Achilles', 'central',   'scholarly'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'Priam',    'central',   'scholarly'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'Hector',   'secondary', 'scholarly');

-- Fails loudly (character_id NOT NULL) if a character key isn't mapped
INSERT INTO depiction_characters (depiction_id, character_id, role, identified_by)
SELECT d.depiction_id, m.character_id, s.role, s.identified_by
FROM stage_depiction_characters s
JOIN vessels v    ON v.vessel_name = s.vessel_name
JOIN depictions d ON d.vessel_id = v.vessel_id AND d.location_on_vessel = s.location
JOIN tmp_iliad_character_map m ON m.char_key = s.character_name;

-- #####################################################################
-- 18. Depiction elements
-- #####################################################################

DROP TEMPORARY TABLE IF EXISTS stage_depiction_elements;
CREATE TEMPORARY TABLE stage_depiction_elements (
  vessel_name   VARCHAR(200) NOT NULL,
  location      VARCHAR(20)  NOT NULL,
  element_name  VARCHAR(120) NOT NULL
);

INSERT INTO stage_depiction_elements (vessel_name, location, element_name) VALUES

-- Briseis taken (Makron, side A)
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'leading by the wrist'),
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'herald''s staff'),
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'tree'),
('Makron Skyphos (Briseis and the Embassy)', 'side_a', 'name inscription'),

-- Embassy (Makron, side B)
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'persuasion scene'),
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'spear'),
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'stool'),
('Makron Skyphos (Briseis and the Embassy)', 'side_b', 'name inscription'),

-- Embassy (Eucharides Painter, side B)
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'persuasion scene'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'suspended armor'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_b', 'stool'),

-- Embassy (Berlin F2176)
('Berlin Hydria F2176 (Embassy to Achilles)', 'shoulder', 'persuasion scene'),
('Berlin Hydria F2176 (Embassy to Achilles)', 'shoulder', 'suspended armor'),

-- Embassy (Clinic Painter)
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'persuasion scene'),
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'suspended armor'),
('Clinic Painter Aryballos (Embassy to Achilles)', 'other', 'name inscription'),

-- Dolon
('Dolon Painter Calyx-Krater', 'side_a', 'ambush and capture'),
('Dolon Painter Calyx-Krater', 'side_a', 'wolf skin'),
('Dolon Painter Calyx-Krater', 'side_a', 'bow'),
('Dolon Painter Calyx-Krater', 'side_a', 'quiver'),
('Dolon Painter Calyx-Krater', 'side_a', 'spear'),
('Dolon Painter Calyx-Krater', 'side_a', 'sword'),
('Dolon Painter Calyx-Krater', 'side_a', 'helmet'),
('Dolon Painter Calyx-Krater', 'side_a', 'tree'),

-- Sarpedon (Euphronios)
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'carrying the dead'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'corpse'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'shield'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'spear'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'helmet'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'name inscription'),
('Euphronios Krater (Sarpedon Krater)', 'side_a', 'artist signature'),

-- Sarpedon (Eucharides Painter)
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_a', 'carrying the dead'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_a', 'corpse'),
('Eucharides Painter Calyx-Krater (Sarpedon and the Embassy)', 'side_a', 'name inscription'),

-- Euphorbos plate
('Euphorbos Plate', 'interior', 'duel'),
('Euphorbos Plate', 'interior', 'corpse'),
('Euphorbos Plate', 'interior', 'shield'),
('Euphorbos Plate', 'interior', 'helmet'),
('Euphorbos Plate', 'interior', 'name inscription'),

-- Death of Hektor (Berlin Painter)
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'duel'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'spear'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'shield'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'helmet'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'bow'),
('Berlin Painter Volute-Krater (Achilles and Hektor)', 'neck', 'name inscription'),

-- Dragging of Hektor (Boston)
('Boston Hydria (Dragging of Hektor)', 'side_a', 'dragging the corpse'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'chariot'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'corpse'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'mourning'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'tomb mound'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'eidolon'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'snake'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'shield'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'city gate or palace'),
('Boston Hydria (Dragging of Hektor)', 'side_a', 'name inscription'),

-- Funeral games (Francois Vase)
('François Vase', 'neck', 'chariot race'),
('François Vase', 'neck', 'chariot'),
('François Vase', 'neck', 'tripod'),
('François Vase', 'neck', 'prize cauldron'),
('François Vase', 'neck', 'turning post'),
('François Vase', 'neck', 'name inscription'),
('François Vase', 'neck', 'artist signature'),

-- Funeral games (Sophilos)
('Sophilos Dinos Fragment (Games of Patroklos)', 'other', 'chariot race'),
('Sophilos Dinos Fragment (Games of Patroklos)', 'other', 'grandstand'),
('Sophilos Dinos Fragment (Games of Patroklos)', 'other', 'scene label'),
('Sophilos Dinos Fragment (Games of Patroklos)', 'other', 'name inscription'),
('Sophilos Dinos Fragment (Games of Patroklos)', 'other', 'artist signature'),

-- Ransom of Hektor (Brygos Painter)
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'kline'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'table with meat'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'corpse'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'ransom gifts'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'suspended armor'),
('Brygos Painter Skyphos (Ransom of Hektor)', 'side_a', 'tent');

INSERT INTO depiction_elements (depiction_id, element_id)
SELECT d.depiction_id, e.element_id
FROM stage_depiction_elements s
JOIN vessels v    ON v.vessel_name = s.vessel_name
JOIN depictions d ON d.vessel_id = v.vessel_id AND d.location_on_vessel = s.location
JOIN elements e   ON e.name = s.element_name;

-- #####################################################################
-- 19. Images
-- #####################################################################

INSERT INTO images (vessel_id, depiction_id, url, credit, license, image_type, hosted_or_linked) VALUES

-- Berlin Painter volute-krater (BM 1848,0801.1)
((SELECT vessel_id FROM vessels WHERE vessel_name = 'Berlin Painter Volute-Krater (Achilles and Hektor)'),
 NULL,
 'https://www.britishmuseum.org/collection/image/97950001',
 '© The Trustees of the British Museum', 'CC BY-NC-SA 4.0', 'full_view', 'linked'),

((SELECT vessel_id FROM vessels WHERE vessel_name = 'Berlin Painter Volute-Krater (Achilles and Hektor)'),
 (SELECT d.depiction_id FROM depictions d JOIN vessels v ON v.vessel_id = d.vessel_id
  WHERE v.vessel_name = 'Berlin Painter Volute-Krater (Achilles and Hektor)' AND d.location_on_vessel = 'neck'),
 'https://www.britishmuseum.org/collection/image/480676001',
 '© The Trustees of the British Museum', NULL, 'detail', 'linked'),

-- Dolon Painter calyx-krater (BM 1846,0925.3)
((SELECT vessel_id FROM vessels WHERE vessel_name = 'Dolon Painter Calyx-Krater'),
 (SELECT d.depiction_id FROM depictions d JOIN vessels v ON v.vessel_id = d.vessel_id
  WHERE v.vessel_name = 'Dolon Painter Calyx-Krater' AND d.location_on_vessel = 'side_a'),
 'https://www.britishmuseum.org/collection/image/1261893001',
 '© The Trustees of the British Museum', NULL, 'other', 'linked'),

-- Brygos Painter skyphos (Vienna IV 3710)
((SELECT vessel_id FROM vessels WHERE vessel_name = 'Brygos Painter Skyphos (Ransom of Hektor)'),
 (SELECT d.depiction_id FROM depictions d JOIN vessels v ON v.vessel_id = d.vessel_id
  WHERE v.vessel_name = 'Brygos Painter Skyphos (Ransom of Hektor)' AND d.location_on_vessel = 'side_a'),
 'https://artsandculture.google.com/asset/brygos-skyphos/2wE1HdyvVktF5w',
 'Kunsthistorisches Museum Wien, via Google Arts & Culture', NULL, 'full_view', 'linked'),

-- Boston hydria (MFA 63.473)
((SELECT vessel_id FROM vessels WHERE vessel_name = 'Boston Hydria (Dragging of Hektor)'),
 (SELECT d.depiction_id FROM depictions d JOIN vessels v ON v.vessel_id = d.vessel_id
  WHERE v.vessel_name = 'Boston Hydria (Dragging of Hektor)' AND d.location_on_vessel = 'side_a'),
 'https://artsandculture.google.com/asset/water-jar-hydria/LAHAxy0qj3hFAA',
 'Museum of Fine Arts, Boston (William Francis Warden Fund), via Google Arts & Culture', 'All rights reserved', 'full_view', 'linked');

-- #####################################################################
-- 20. Related media
-- #####################################################################

DROP TEMPORARY TABLE IF EXISTS stage_related_media;
CREATE TEMPORARY TABLE stage_related_media (
  story_key       VARCHAR(40)  NOT NULL,
  media_type      VARCHAR(60)  NOT NULL,
  title           VARCHAR(255) NOT NULL,
  creator         VARCHAR(200) NULL,
  media_year      SMALLINT     NULL,
  media_language  VARCHAR(60)  NULL
);

INSERT INTO stage_related_media (story_key, media_type, title, creator, media_year, media_language) VALUES
('hector_duel',     'film',     'Troy',                         'Wolfgang Petersen',  2004, 'English'),
('ransom',          'opera',    'King Priam',                   'Michael Tippett',    1962, 'English'),
('ransom',          'painting', 'Andromache Mourning Hector',   'Jacques-Louis David',1783, NULL),
('death_patroclus', 'novel',    'The Song of Achilles',         'Madeline Miller',    2011, 'English'),
('briseis',         'novel',    'The Silence of the Girls',     'Pat Barker',         2018, 'English');

INSERT INTO related_media (story_id, media_type_id, title, creator, media_year, media_language, url, aia_resource_link)
SELECT (SELECT st.story_id FROM stories st JOIN tmp_iliad_story_map sm ON st.name = sm.story_name
        WHERE sm.story_key = s.story_key ORDER BY st.story_id LIMIT 1),
       mt.media_type_id, s.title, s.creator, s.media_year, s.media_language, NULL, NULL
FROM stage_related_media s
JOIN media_types mt ON mt.name = s.media_type;

-- #####################################################################
-- 99. Cleanup
-- #####################################################################

DROP TABLE IF EXISTS tmp_iliad_story_map;
DROP TABLE IF EXISTS tmp_iliad_character_map;