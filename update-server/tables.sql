create table if not exists packages_hashes (
	hash text primary key,
    packages text
);

create table if not exists releases (
    distro text,
    release text,
    PRIMARY KEY (distro, release)
);

create table if not exists targets (
    distro text,
    release text,
    target text,
    subtarget text,
	supported bool DEFAULT false,
    PRIMARY KEY (distro, release, target, subtarget),
    FOREIGN KEY (distro, release) REFERENCES releases
);

create table if not exists packages (
    distro text,
    release text,
    target text,
    subtarget text,
    name text,
    version text,
    FOREIGN KEY (distro, release, target, subtarget) REFERENCES targets
);

create table if not exists profiles (
    distro text,
    release text,
    target text,
    subtarget text,
    name text,
    board text,
    packages text,
    PRIMARY KEY(distro, release, target, subtarget, name, board),
    FOREIGN KEY (distro, release, target, subtarget) REFERENCES targets
);

create table if not exists default_packages (
    distro text,
    release text,
    target text,
    subtarget text,
    packages text,
    PRIMARY KEY (distro, release, target, subtarget),
    FOREIGN KEY (distro, release, target, subtarget) REFERENCES targets
);

create table if not exists imagebuilder (
    id SERIAL PRIMARY KEY,
    distro text,
    release text,
    target text,
    subtarget text,
    status varchar(20) DEFAULT 'requested', -- 'ready', 'disabled', 'failded'
    FOREIGN KEY (distro, release, target, subtarget) REFERENCES targets
);

create table if not exists images (
    id SERIAL PRIMARY KEY,
    image_hash text UNIQUE,
    distro text,
    release text,
    target text,
    subtarget text,
    profile text,
    package_hash text,
    network_profile text,
    checksum text,
	filesize integer,
	build_date timestamp,
	last_download timestamp,
	downloads integer DEFAULT 0,
	keep boolean DEFAULT false,
    status text DEFAULT 'requested',
    FOREIGN KEY (distro, release, target, subtarget) REFERENCES targets,
    FOREIGN KEY (package_hash) REFERENCES packages_hashes(hash)
)
