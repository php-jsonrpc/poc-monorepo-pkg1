<?php
namespace Tests\Behat\Context;

use Behat\Behat\Context\Context;
use PhpJsonrpc\PocMonorepoPkg1\Model\Dummy;
use PHPUnit\Framework\Assert;
use Psr\Log\LoggerInterface;
use Psr\Log\NullLogger;

class DummyContext implements Context
{
    private ?Dummy $instance;
    private ?LoggerInterface $loggerInstance;

    /**
     * @Given I create a Dummy class instance
     */
    public function givenICreateADummyClassInstance(): void
    {
        $this->loggerInstance = new NullLogger();
        $this->instance = new Dummy($this->loggerInstance);
    }

    /**
     * @Then instance should have the right logger attached
     */
    public function thenInstanceShouldHaveTheRightLoggerAttached(): void
    {
        Assert::assertInstanceOf(Dummy::class, $this->instance);
        Assert::assertSame($this->loggerInstance, $this->instance->getLogger());
    }
}
