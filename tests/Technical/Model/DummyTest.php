<?php
namespace Tests\Technical\Model;

use PhpJsonrpc\PocMonorepoPkg1\Model\Dummy;
use PHPUnit\Framework\TestCase;

/**
 * @covers \PhpJsonrpc\PocMonorepoPkg1\Model\Dummy
 */
class DummyTest extends TestCase
{
    public function testShouldWork(): void
    {
        self::assertInstanceOf(Dummy::class, new Dummy());
    }
}
