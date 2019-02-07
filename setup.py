from setuptools import setup

setup(
    name='silica',
    version='0.1-alpha',
    description='',
    packages=["silica", "silica.cfg"],
    install_requires=[
        "orderedset",
        "fault>=1.0.0, <=1.0.13",
        "python-constraint"
    ]
)
