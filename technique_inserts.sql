-- =====================================================================
-- Seed data for the techniques table (merged)
-- Run after create_pottery_schema.sql
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
-- Confirm both licenses before publishing this data.
-- =====================================================================

USE pottery;

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

-- Verify
SELECT category, source, COUNT(*) AS n
FROM techniques
GROUP BY category, source
ORDER BY source, category;