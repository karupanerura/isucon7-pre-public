ALTER TABLE channel ADD COLUMN count int(10) unsigned NOT NULL DEFAULT 0;
ALTER TABLE haveread ADD COLUMN count int(10) unsigned NOT NULL DEFAULT 0;

alter table channel add key on_count (count);
alter table haveread add key on_count (count);

