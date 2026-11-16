-- =====================================================================
-- Ancient Greek Pots and Myths Catalogue
-- MySQL 8.0 schema (InnoDB, utf8mb4)
-- Dates: BCE stored as negative integers (e.g. -530 = 530 BCE)
-- =====================================================================

DROP DATABASE IF EXISTS pottery;
CREATE DATABASE pottery
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE pottery;

-- ---------------------------------------------------------------------
-- LOOKUP TABLES
-- ---------------------------------------------------------------------

CREATE TABLE myths (
  myth_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name           VARCHAR(150) NOT NULL,
  PRIMARY KEY (myth_id),
  UNIQUE KEY uq_myths_name (name)
) ENGINE=InnoDB;

CREATE TABLE shapes (
  shape_id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name                 VARCHAR(80)  NOT NULL,
  greek_name           VARCHAR(80)  NULL,
  function_category    ENUM('mixing','drinking','storage','pouring','oil_perfume','other') NOT NULL DEFAULT 'other',
  purpose_description  TEXT NULL,
  PRIMARY KEY (shape_id),
  UNIQUE KEY uq_shapes_name (name)
) ENGINE=InnoDB;

CREATE TABLE techniques (
  technique_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name           VARCHAR(80) NOT NULL,   -- black-figure, red-figure, white-ground, etc.
  PRIMARY KEY (technique_id),
  UNIQUE KEY uq_techniques_name (name)
) ENGINE=InnoDB;

CREATE TABLE regions (
  region_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  parent_region_id  INT UNSIGNED NULL,   -- e.g. Etruria -> Italy
  name              VARCHAR(120) NOT NULL,
  modern_country    VARCHAR(80)  NULL,
  latitude          DECIMAL(9,6) NULL,
  longitude         DECIMAL(9,6) NULL,
  pleiades_id       VARCHAR(30)  NULL,
  PRIMARY KEY (region_id),
  KEY ix_regions_parent (parent_region_id),
  CONSTRAINT fk_regions_parent FOREIGN KEY (parent_region_id)
    REFERENCES regions (region_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE museums (
  museum_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name       VARCHAR(200) NOT NULL,
  city       VARCHAR(100) NULL,
  country    VARCHAR(80)  NULL,
  PRIMARY KEY (museum_id)
) ENGINE=InnoDB;

CREATE TABLE archives (
  archive_id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name           VARCHAR(150) NOT NULL,  -- Beazley Archive, Tufts, DAR, etc.
  base_url       VARCHAR(255) NULL,
  license_terms  TEXT NULL,
  PRIMARY KEY (archive_id),
  UNIQUE KEY uq_archives_name (name)
) ENGINE=InnoDB;

CREATE TABLE workshops (
  workshop_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name         VARCHAR(150) NOT NULL,
  notes        TEXT NULL,
  PRIMARY KEY (workshop_id)
) ENGINE=InnoDB;

CREATE TABLE elements (
  element_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name        VARCHAR(120) NOT NULL,     -- wooden horse, dice game, chariot, etc.
  category    ENUM('object','action','inscription','setting') NOT NULL DEFAULT 'object',
  PRIMARY KEY (element_id),
  UNIQUE KEY uq_elements_name (name)
) ENGINE=InnoDB;

CREATE TABLE media_types (
  media_type_id  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name           VARCHAR(60) NOT NULL,   -- film, opera, painting, novel, game
  PRIMARY KEY (media_type_id),
  UNIQUE KEY uq_media_types_name (name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- CORE TABLES
-- ---------------------------------------------------------------------

CREATE TABLE stories (
  story_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  myth_id          INT UNSIGNED NOT NULL,
  parent_story_id  INT UNSIGNED NULL,    -- Trojan War -> Death of Hector -> scene
  name             VARCHAR(200) NOT NULL,
  literary_source  VARCHAR(200) NULL,    -- Iliad 22, Aethiopis, Little Iliad, etc.
  PRIMARY KEY (story_id),
  KEY ix_stories_myth (myth_id),
  KEY ix_stories_parent (parent_story_id),
  CONSTRAINT fk_stories_myth FOREIGN KEY (myth_id)
    REFERENCES myths (myth_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_stories_parent FOREIGN KEY (parent_story_id)
    REFERENCES stories (story_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE characters (
  character_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name            VARCHAR(120) NOT NULL,
  alt_spellings   VARCHAR(255) NULL,     -- Achilleus; Achilles
  type            VARCHAR(60)  NULL,     -- hero, god, mortal, monster
  side            ENUM('greek','trojan','divine','other') NOT NULL DEFAULT 'other',
  PRIMARY KEY (character_id),
  KEY ix_characters_name (name)
) ENGINE=InnoDB;

CREATE TABLE artists (
  artist_id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  workshop_id   INT UNSIGNED NULL,
  name          VARCHAR(150) NOT NULL,   -- includes conventional names, e.g. Achilles Painter
  role          ENUM('painter','potter','both','unknown') NOT NULL DEFAULT 'unknown',
  active_start  SMALLINT NULL,
  active_end    SMALLINT NULL,
  PRIMARY KEY (artist_id),
  KEY ix_artists_workshop (workshop_id),
  CONSTRAINT fk_artists_workshop FOREIGN KEY (workshop_id)
    REFERENCES workshops (workshop_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vessels (
  vessel_id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  shape_id               INT UNSIGNED NULL,
  technique_id           INT UNSIGNED NULL,
  findspot_region_id     INT UNSIGNED NULL,
  production_region_id   INT UNSIGNED NULL,
  findspot_certainty     ENUM('certain','probable','unknown') NOT NULL DEFAULT 'unknown',
  production_certainty   ENUM('certain','probable','unknown') NOT NULL DEFAULT 'unknown',
  museum_id              INT UNSIGNED NULL,
  accession_number       VARCHAR(80) NULL,
  vessel_name            VARCHAR(200) NULL,
  date_start             SMALLINT NULL,
  date_end               SMALLINT NULL,
  period_label           ENUM('geometric','archaic','classical','hellenistic','roman') NULL,
  dating_basis           VARCHAR(255) NULL,
  vessel_description     TEXT NULL,
  review_status          ENUM('unreviewed','verified','flagged') NOT NULL DEFAULT 'unreviewed',
  created_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (vessel_id),
  KEY ix_vessels_shape (shape_id),
  KEY ix_vessels_technique (technique_id),
  KEY ix_vessels_findspot (findspot_region_id),
  KEY ix_vessels_production (production_region_id),
  KEY ix_vessels_museum (museum_id),
  KEY ix_vessels_dates (date_start, date_end),
  CONSTRAINT chk_vessels_dates CHECK (date_start IS NULL OR date_end IS NULL OR date_start <= date_end),
  CONSTRAINT fk_vessels_shape FOREIGN KEY (shape_id)
    REFERENCES shapes (shape_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_vessels_technique FOREIGN KEY (technique_id)
    REFERENCES techniques (technique_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_vessels_findspot FOREIGN KEY (findspot_region_id)
    REFERENCES regions (region_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_vessels_production FOREIGN KEY (production_region_id)
    REFERENCES regions (region_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_vessels_museum FOREIGN KEY (museum_id)
    REFERENCES museums (museum_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE depictions (
  depiction_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  vessel_id           INT UNSIGNED NOT NULL,
  story_id            INT UNSIGNED NULL,
  location_on_vessel  ENUM('side_a','side_b','neck','shoulder','interior','exterior','handle','foot','other') NOT NULL DEFAULT 'other',
  moment_depicted     VARCHAR(255) NULL,
  description         TEXT NULL,
  notes               TEXT NULL,
  raw_source_text     TEXT NULL,
  extraction_method   VARCHAR(80) NULL,   -- e.g. claude_extraction, manual
  confidence          DECIMAL(3,2) NULL,  -- 0.00 to 1.00
  review_status       ENUM('unreviewed','verified','flagged') NOT NULL DEFAULT 'unreviewed',
  PRIMARY KEY (depiction_id),
  KEY ix_depictions_vessel (vessel_id),
  KEY ix_depictions_story (story_id),
  CONSTRAINT chk_depictions_conf CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 1)),
  CONSTRAINT fk_depictions_vessel FOREIGN KEY (vessel_id)
    REFERENCES vessels (vessel_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_depictions_story FOREIGN KEY (story_id)
    REFERENCES stories (story_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE images (
  image_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  vessel_id        INT UNSIGNED NOT NULL,
  depiction_id     INT UNSIGNED NULL,
  url              VARCHAR(500) NOT NULL,
  credit           VARCHAR(255) NULL,
  license          VARCHAR(150) NULL,
  image_type       ENUM('full_view','detail','drawing','other') NOT NULL DEFAULT 'full_view',
  hosted_or_linked ENUM('hosted','linked') NOT NULL DEFAULT 'linked',
  PRIMARY KEY (image_id),
  KEY ix_images_vessel (vessel_id),
  KEY ix_images_depiction (depiction_id),
  CONSTRAINT fk_images_vessel FOREIGN KEY (vessel_id)
    REFERENCES vessels (vessel_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_images_depiction FOREIGN KEY (depiction_id)
    REFERENCES depictions (depiction_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE related_media (
  media_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  story_id        INT UNSIGNED NOT NULL,
  media_type_id   INT UNSIGNED NOT NULL,
  title           VARCHAR(255) NOT NULL,
  creator         VARCHAR(200) NULL,
  media_year      SMALLINT NULL,
  media_language  VARCHAR(60) NULL,
  url             VARCHAR(500) NULL,
  aia_resource_link VARCHAR(500) NULL,
  PRIMARY KEY (media_id),
  KEY ix_media_story (story_id),
  KEY ix_media_type (media_type_id),
  CONSTRAINT fk_media_story FOREIGN KEY (story_id)
    REFERENCES stories (story_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_media_type FOREIGN KEY (media_type_id)
    REFERENCES media_types (media_type_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- LINKING TABLES
-- ---------------------------------------------------------------------

CREATE TABLE depiction_characters (
  depiction_id  INT UNSIGNED NOT NULL,
  character_id  INT UNSIGNED NOT NULL,
  role          ENUM('central','secondary','background') NOT NULL DEFAULT 'secondary',
  identified_by ENUM('inscription','attributes','scholarly','unknown') NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (depiction_id, character_id),
  KEY ix_dc_character (character_id),
  CONSTRAINT fk_dc_depiction FOREIGN KEY (depiction_id)
    REFERENCES depictions (depiction_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_dc_character FOREIGN KEY (character_id)
    REFERENCES characters (character_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE depiction_elements (
  depiction_id  INT UNSIGNED NOT NULL,
  element_id    INT UNSIGNED NOT NULL,
  PRIMARY KEY (depiction_id, element_id),
  KEY ix_de_element (element_id),
  CONSTRAINT fk_de_depiction FOREIGN KEY (depiction_id)
    REFERENCES depictions (depiction_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_de_element FOREIGN KEY (element_id)
    REFERENCES elements (element_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE vessel_artists (
  vessel_id         INT UNSIGNED NOT NULL,
  artist_id         INT UNSIGNED NOT NULL,
  attribution_type  ENUM('signed','attributed','manner_of','circle_of','unknown') NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (vessel_id, artist_id),
  KEY ix_va_artist (artist_id),
  CONSTRAINT fk_va_vessel FOREIGN KEY (vessel_id)
    REFERENCES vessels (vessel_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_va_artist FOREIGN KEY (artist_id)
    REFERENCES artists (artist_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE archive_records (
  vessel_id           INT UNSIGNED NOT NULL,
  archive_id          INT UNSIGNED NOT NULL,
  external_record_id  VARCHAR(100) NOT NULL,   -- e.g. Beazley Vase Number
  url                 VARCHAR(500) NULL,
  raw_source_text     MEDIUMTEXT NULL,
  date_scraped        DATE NULL,
  PRIMARY KEY (vessel_id, archive_id),
  UNIQUE KEY uq_archive_external (archive_id, external_record_id),
  CONSTRAINT fk_ar_vessel FOREIGN KEY (vessel_id)
    REFERENCES vessels (vessel_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ar_archive FOREIGN KEY (archive_id)
    REFERENCES archives (archive_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

