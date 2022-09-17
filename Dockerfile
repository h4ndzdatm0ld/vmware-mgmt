##############
# Dependencies
FROM python:3.8 as base

WORKDIR /usr/src/app

RUN pip install -U pip  && \
    curl -sSL https://install.python-poetry.org  | python3 -

ENV PATH="/root/.local/bin:$PATH"

RUN poetry config virtualenvs.create false

# Install project manifest
COPY pyproject.toml poetry.lock ./

# Install production dependencies
RUN poetry install --no-root --no-dev

# VMWARE Package needs help...
RUN pip install setuptools  && \
    pip install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

FROM base AS test

# Copy in the application code
COPY . .

# --no-root declares not to install the project package since we're wanting to take advantage of caching dependency installation
# and the project is copied in and installed after this step
RUN poetry install --no-interaction --no-ansi --no-root

# Simple tests
RUN echo 'Running Flake8' && \
    flake8 . && \
    echo 'Running Black' && \
    black --check --diff . && \
    echo 'Running Pylint' && \
    find . -name '*.py' | xargs pylint  && \
    echo 'Running Yamllint' && \
    yamllint . && \
    echo 'Running pydocstyle' && \
    pydocstyle . && \
    echo 'Running Bandit' && \
    bandit --recursive ./ --configfile .bandit.yml

#############
# Ansible Collections
#
# This installs the Ansible Collections from collections/requirements.yml
# and the roles from roles/requirements.yml, as well as installing git.
FROM base AS ansible

WORKDIR /usr/src/app

# Uncomment if using galaxy installs
# COPY galaxy/requirements.yml galaxy-requirements.yml

ENV ANSIBLE_COLLECTIONS_PATH /usr/share/ansible/collections
ENV ANSIBLE_ROLES_PATH /usr/share/ansible/roles

COPY ./collections/requirements.yml ./collections/requirements.yml
# COPY ./roles/requirements.yml ./roles/requirements.yml

# The conditional logic is here to cover the case where the user deletes the
# collection or role requirements file, in the event that they don't need it.
# The image includes 'fat' Ansible so most folk won't strictly need to
# add collections.
RUN if [ -e collections/requirements.yml ]; then \
    ansible-galaxy collection install -r collections/requirements.yml; \
    fi

#############
# Final image
#
# This creates a runnable CLI container
FROM python:3.8.7-slim AS cli

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y sshpass

COPY --from=base /usr/src/app /usr/src/app
COPY --from=base /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=base /usr/local/bin /usr/local/bin
COPY --from=ansible /usr/share /usr/share

COPY . .

ENTRYPOINT ["ansible-playbook"]
