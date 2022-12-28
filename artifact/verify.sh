#!/bin/bash

INSTALLATION_ERROR_MESSAGE="ERROR : cannot verify installation"

echo "Verifying JDKs installation..."
$JVBENCH_JAVA_HOME/bin/java -version
if [ $? -ne 0 ]; then
    echo -e $INSTALLATION_ERROR_MESSAGE
    exit 13
fi
$JVBENCH_JAVA_HOME_XOR/bin/java -version
if [ $? -ne 0 ]; then
    echo -e $INSTALLATION_ERROR_MESSAGE
    exit 13
fi

echo "Verifying JVBench installation..."
$JVBENCH_JAVA_HOME/bin/java --add-modules jdk.incubator.vector -cp $JVBENCH_JAR -jar $JVBENCH_JAR -f 1 -wi 1 -i 1 -bm SingleShotTime "axpy"
if [ $? -ne 0 ]; then
    echo -e $INSTALLATION_ERROR_MESSAGE
    exit 13
fi
$JVBENCH_JAVA_HOME_XOR/bin/java --add-modules jdk.incubator.vector -cp $JVBENCH_XOR_JAR -jar $JVBENCH_XOR_JAR -f 1 -wi 1 -i 1 -bm SingleShotTime "axpy"
if [ $? -ne 0 ]; then
    echo -e $INSTALLATION_ERROR_MESSAGE
    exit 13
fi

echo "Verifying postprocessing scripts installation..."
cd postprocessing
python3.9 main.py --help
if [ $? -ne 0 ]; then
    echo -e $INSTALLATION_ERROR_MESSAGE
    exit 13
fi
cd ..

echo "Verifying benchmark runner scripts installation..."
cd benchmark_runner
python3.9 runner.py --help
if [ $? -ne 0 ]; then
    echo -e $INSTALLATION_ERROR_MESSAGE
    exit 13
fi
cd ..

echo "The artifact is correctly installed"
