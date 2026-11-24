-- =====================================================================
-- Seed data for the archives table
-- Run after create_pottery_schema.sql
-- license_terms are summaries, not legal text. Confirm each source's
-- current terms before scraping, storing, or republishing anything.
-- =====================================================================

USE pottery;

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

-- Verify
SELECT archive_id, name, base_url FROM archives ORDER BY archive_id;