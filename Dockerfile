FROM golang:1.18.2-alpine3.15 AS base    
RUN mkdir /app   
COPY .   /app         
WORKDIR /app      
RUN go build -o main .  


FROM alpine       
WORKDIR /app  
COPY --from=base /app/ /app/
EXPOSE 8080 
CMD ["./main"]