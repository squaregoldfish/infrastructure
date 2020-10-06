.PHONE: status

status:
	@for f in *; do					      \
		[ -f "$$f/docker-compose.yml" ] || continue;  \
                cd "$$f" 2>/dev/null || continue;	      \
                printf "\n\t--- $$f ---\n";		      \
                docker-compose ps;			      \
                cd ..;					      \
        done


