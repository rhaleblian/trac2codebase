CREATE TABLE attachment (
    type text,
    id text,
    filename text,
    size integer,
    time integer,
    description text,
    author text,
    ipnr text,
    UNIQUE (type,id,filename)
);
CREATE TABLE auth_cookie (
    cookie text,
    name text,
    ipnr text,
    time integer,
    UNIQUE (cookie,ipnr,name)
);
CREATE TABLE cache (
    id text PRIMARY KEY,
    generation integer
);
CREATE TABLE component (
    name text PRIMARY KEY,
    owner text,
    description text
);
CREATE TABLE enum (
    type text,
    name text,
    value text,
    UNIQUE (type,name)
);
CREATE TABLE milestone (
    name text PRIMARY KEY,
    due integer,
    completed integer,
    description text
);
CREATE TABLE node_change (
    repos integer,
    rev text,
    path text,
    node_type text,
    change_type text,
    base_path text,
    base_rev text,
    UNIQUE (repos,rev,path,change_type)
);
CREATE TABLE permission (
    username text,
    action text,
    UNIQUE (username,action)
);
CREATE TABLE report (
    id integer PRIMARY KEY,
    author text,
    title text,
    query text,
    description text
);
CREATE TABLE repository (
    id integer,
    name text,
    value text,
    UNIQUE (id,name)
);
CREATE TABLE revision (
    repos integer,
    rev text,
    time integer,
    author text,
    message text,
    UNIQUE (repos,rev)
);
CREATE TABLE session (
    sid text,
    authenticated integer,
    last_visit integer,
    UNIQUE (sid,authenticated)
);
CREATE TABLE session_attribute (
    sid text,
    authenticated integer,
    name text,
    value text,
    UNIQUE (sid,authenticated,name)
);
CREATE TABLE system (
    name text PRIMARY KEY,
    value text
);
CREATE TABLE ticket (
    id integer PRIMARY KEY,
    type text,
    time integer,
    changetime integer,
    component text,
    severity text,
    priority text,
    owner text,
    reporter text,
    cc text,
    version text,
    milestone text,
    status text,
    resolution text,
    summary text,
    description text,
    keywords text
);
CREATE TABLE ticket_change (
    ticket integer,
    time integer,
    author text,
    field text,
    oldvalue text,
    newvalue text,
    UNIQUE (ticket,time,field)
);
CREATE TABLE ticket_custom (
    ticket integer,
    name text,
    value text,
    UNIQUE (ticket,name)
);
CREATE TABLE version (
    name text PRIMARY KEY,
    time integer,
    description text
);
CREATE TABLE wiki (
    name text,
    version integer,
    time integer,
    author text,
    ipnr text,
    text text,
    comment text,
    readonly integer,
    UNIQUE (name,version)
);
CREATE INDEX node_change_repos_rev_idx ON node_change (repos,rev);
CREATE INDEX revision_repos_time_idx ON revision (repos,time);
CREATE INDEX session_authenticated_idx ON session (authenticated);
CREATE INDEX session_last_visit_idx ON session (last_visit);
CREATE INDEX ticket_change_ticket_idx ON ticket_change (ticket);
CREATE INDEX ticket_change_time_idx ON ticket_change (time);
CREATE INDEX ticket_status_idx ON ticket (status);
CREATE INDEX ticket_time_idx ON ticket (time);
CREATE INDEX wiki_time_idx ON wiki (time);
