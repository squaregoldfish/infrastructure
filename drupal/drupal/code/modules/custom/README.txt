See conf/site.yml for linking/copying configuration.

# simpleauth
A module that take for granted that some authentication has been externally done
and take a few URL params to compose an unique username and then load the user from the database.
If the user doesn't exists the user will be created.
The module will also support a creation of a link to a external login service.

