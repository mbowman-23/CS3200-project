-- =====================================================================
-- Seed data for the shapes table
-- Run after create_pottery_schema.sql
--
-- Source: Cartwright, M. (2013, May 24). A Visual Glossary of Greek
-- Pottery. World History Encyclopedia.
-- https://www.worldhistory.org/article/489/a-visual-glossary-of-greek-pottery/
--
-- Descriptions are paraphrased summaries. Only vessel shapes are included;
-- function_category falls back to 'other' where the source gives no
-- clear match to the enum (serving, ritual, washing, textile work).
-- =====================================================================

USE pottery;

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

-- Verify
SELECT function_category, COUNT(*) AS n FROM shapes GROUP BY function_category ORDER BY n DESC;