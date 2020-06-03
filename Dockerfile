# develop stage
FROM node:alpine as develop-stage
WORKDIR /app

#Create environment variables
ARG var_API_URL
ARG var_API_URL=value
ENV API_URL=${var_KeyVault_Url}


COPY package*.json ./
RUN npm install
COPY . .

# build stage
FROM develop-stage as build-stage
RUN npm run-script build

# production stage
FROM nginx:alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]