from setuptools import setup

setup(
    name='silica',
    version='0.1-alpha',
    description='',
    packages=["silica", "silica.cfg"],
    install_requires=[
        "orderedset",
        "python-constraint"
    ]
)
