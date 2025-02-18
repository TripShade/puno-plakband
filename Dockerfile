FROM node:lts-alpine AS development

LABEL org.opencontainers.image.authors="René van Spronsen"

# Create app directory
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY --chown=1000:1000 package*.json ./

RUN npm install

# Bundle app source
COPY --chown=1000:1000 . .

# Use the 1000 user from the image (instead of the root user)
USER 1000

###################
# BUILD FOR PRODUCTION
###################

FROM node:lts-alpine AS build

WORKDIR /usr/src/app

COPY --chown=1000:1000 package*.json ./

# In order to run `npm run build` we need access to the Nest CLI which is a dev dependency. In the previous development stage we ran `npm ci` which installed all dependencies, so we can copy over the node_modules directory from the development image
COPY --chown=1000:1000 --from=development /usr/src/app/node_modules ./node_modules

COPY --chown=1000:1000 . .

# Set NODE_ENV environment variable
ENV NODE_ENV production

# Run the build command which creates the production bundle
RUN npm run build

# Running `npm ci` removes the existing node_modules directory and passing in --only=production ensures that only the production dependencies are installed. This ensures that the node_modules directory is as optimized as possible
RUN npm ci --only=production && npm cache clean --force

USER 1000

###################
# PRODUCTION
###################

FROM node:lts-alpine AS production

# Copy the bundled code from the build stage to the production image
COPY --chown=1000:1000 --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=1000:1000 --from=build /usr/src/app/dist ./dist

USER node

# # Start the server using the production build
CMD [ "node", "dist/main.js" ]